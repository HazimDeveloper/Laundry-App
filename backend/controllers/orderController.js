const { where } = require("sequelize");
const {
  Order,
  Customer,
  Service,
  OrderItem,
  User,
  Address,
  Payment,
} = require("../models");
const order = require("../models/order");
const service = require("../models/service");

const orderController = {
  createOrder: async (req, res) => {
    try {
      const { customerId, serviceId, services, addressId } = req.body;

      const customer = await Customer.findByPk({ where: { id: customerId } });

      if (!customer) {
        return res.status(404).json({ message: "Customer not found" });
      }

      const user = await User.findByPk(customer.userId);
      if (!user) {
        return res.status(404).json({ message: "User not found" });
      }

      const address = await Address.findByOne({
        where: { id: addressId, customerId: customerId },
      });

      if (!address) {
        return res.status(404).json({ message: "Address not found" });
      }

      const order = await Order.create({
        customerId: customerId,
        userId: user.id,
        status: "pending",
      });

      let total = 0;
      //add all service price to total
      for (let serviceItem of services) {
        const service = await Service.findByPk(serviceItem.serviceId);
        if (!service) {
          return res.status(404).json({ message: "Service not found" });
        }

        await OrderItem.create({
          orderId: order.id,
          serviceId: serviceItem.serviceId,
          quantity: serviceItem.quantity,
          price: service.price,
        });

        total += service.price * serviceItem.quantity;
      }

      await order.update({ total: total });

      //fetch complete order item

      const completerOrder = await Order.findByPk(order.id, {
        include: [
          { model: Customer },
          { model: Service, through: OrderItem },
          { model: User },
          { model: Address },
        ],
      });
      res.status(200).json(completerOrder);
    } catch (error) {
      console.error("Error creating order:", error);
      res.status(500).json({ error: "An error occurred while creating order" });
    }
  },

  getOrderHistory: async (req, res) => {
    try {
      const { customerId } = req.params;

      const customer = await Customer.findByPk({ where: { id: customerId } });
      if (!customer) {
        return res.status(404).json({ message: "Customer not found" });
      }

      const orderHistory = await Order.findAll({
        where: { customerId: customerId },
        include: [
          //Service model
          {
            model: Service,
            through: {
              model: OrderItem,
              attributes: ["quantity", "price"],
            },
          },
          //Address model
          {
            model: Address,
            attributes: ["street", "city", "state", "postal_code"],
          },
          //Payment model
          {
            model: Payment,
            attributes: [
              "amount",
              "payment_method",
              "transaction_id",
              "status",
              "timestamp",
            ],
          },
          //User model
          {
            model: User,
            attributes: ["name", "email"],
          },
        ],
        order: [["createdAt", "DESC"]],
      });
    } catch (error) {
      console.error("Error retrieving order history:", error);
      res
        .status(500)
        .json({ error: "An error occurred while retrieving order history" });
    }
  },
  updateOrderStatus: async (req, res) => {
    try {
      const { orderId } = req.body;
      const { status } = req.params;
      const order = await Order.findByPk(orderId);

      if (!order) {
        return res.status(404).json({ message: "order not found" });
      }

      if (["pending", "in process", "complete"].indexOf(status) === -1) {
        return res.status(400).json({ message: "invalid status" });
      }

      await order.update({ status });

      const orderUpdated = await Order.findByPk(orderId, {
        include: [
          { model: Customer },
          { model: User },
          { model: Service, through: OrderItem },
          { model: Address },
        ],
      });

      res.json(orderUpdated);
    } catch (error) {
      console.error("Error updating order status:", error);
      res
        .status(500)
        .json({ error: "An error occurred while updating order status" });
    }
  },
  getDetailedOrder: async (req, res) => {
    try {
      const { startDate, endDate, status } = req.query;
      let whereClause = {};

      if (startDate && endDate) {
        whereClause = {
          createdAt: {
            [Op.between]: [startDate, endDate],
          },
        };
      }

      if (status) {
        whereClause.status = status;
      }

      const order = await Order.findAll({
        where: whereClause,
        include: [
          { model: Service, through: { attributes: ["quantity"] } },
          {
            model: Customer,
            attributes: ["name", "email"],
          },
        ],
        attributes: [
          "id",
          "createdAt",
          "total",
          "status",
          "hoursToComplete",
          "pickupDateTime",
        ],
        order: [["createdAt", "DESC"]],
      });

      const formattedOrders = Order.map((order) => ({
        id: order.id,
        dateOrdered : order.createdAt,
        services: order.Service.map((service) => ({
            name: service.name,
            price: service.price,
            quantity: service.OrderItem.quantity
        })),
        total: order.total,
        status: order.status,
        hoursToComplete: order.hoursToComplete,
        pickupDateTime: order.pickupDateTime,
        customer: order.Customer ? {
          name: order.Customer.name,
          email: order.Customer.email
        }: null,
      }));

      res.json(formattedOrders);
    } catch (error) {
      console.error("Error getting detailed order:", error);
      res.status(500).json({ error: "An error occurred while getting detailed order" });
    }
  },

  setPickupDateTime: async (req, res) => {
    try{

        const { orderId }  =req.params;
        const { pickupDateTime } = req.body;    

        const order = await Order.findByPk(orderId);

        if(!order){
            return res.status(404).json({ message: "Order not found" });
        }

        await order.update({ pickupDateTime: new Date(pickupDateTime) });

        res.json({ message: "Pickup date time set successfully" });

    }catch(error){
      console.error("Error setting pickup date time:", error);
      res.status(500).json({ error: "An error occurred while setting pickup date time" });
    }
  
    
  },
  getOrderDetailsAfterPayment : async (req, res) => {
    try{
      const { orderId } = req.params;
      const order = await Order.findByPk(orderId, {
        where: {
          id: orderId
        },
        include: [
          { model: User,attributes: ["name"] },
          { model: Service, through: { attributes: ["quantity"] } },
          {
            model: Customer,
            attributes: ["name", "phone"],
          },
          {
            model: Address,
            attributes: ['street', 'city', 'state', 'postalCode']
          },
          {
            model: Service,
            through: { attributes: ["quantity"] },
          },
          {
            model: Payment,
            attributes: ['amount', 'paymentMethod', 'status'],
            order: [['createdAt', 'DESC']],
            limit: 1
          }
        ]
      });

      if(!order){
        return res.status(404).json({ message: "Order not found" });
      }

      const latestPayment = order.Payment[0];
      if(!latestPayment || latestPayment.status !== "complete"){
        return res.status(404).json({ message: "Payment not found" });
      }

      const orderDetails = {
        customerName: order.Customer.name,
        phoneNumber: order.Customer.phone,
        service: order.Service.map((service) => ({
          name: service.name,
          quantity: service.OrderItem.quantity
        })),
        orderDate: order.createdAt,
        address: order.Address ? `${order.Address.street}, ${order.Address.city}, ${order.Address.state} ${order.Address.postalCode}` : 'No address provided',
        urgencyType: order.urgencyType,
        total: order.total,
        paymentMethod: latestPayment.paymentMethod,
        status: latestPayment.status,
        hoursToComplete: order.hoursToComplete,
        pickupDateTime: order.pickupDateTime,
        assignedTo: Order.user ? order.user.name : 'Not assigned'


      };
      res.json(orderDetails);
    }catch(error){
      console.error("Error setting pickup date time:", error);
      res.status(500).json({ error: "An error occurred while setting pickup date time" });
    }
  }

    
  
};

module.exports = orderController;
