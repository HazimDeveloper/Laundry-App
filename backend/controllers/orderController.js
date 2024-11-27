const { where, Op } = require("sequelize");
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
  getOrderHistory: async (req, res) => {
    try {
      // Get user ID from auth middleware
      const userId = req.user.id;

      const orders = await Order.findAll({
        include: [
          {
            model: Service,
            through: {
              attributes: ['quantity', 'price']
            }
          },
          {
            model: Customer,
            attributes: ['name', 'phone']
          }
        ],
        order: [['createdAt', 'DESC']]
      });

      // Format the orders data
      const formattedOrders = orders.map(order => ({
        id: order.id,
        service: order.Services.map(s => s.name).join(', '),
        dateTime: order.createdAt.toISOString(),
        status: order.status,
        total: order.Services.reduce((sum, service) => 
          sum + (service.OrderItem.quantity * service.OrderItem.price), 0
        ).toFixed(2)
      }));

      res.json(formattedOrders);
    } catch (error) {
      console.error('Error fetching order history:', error);
      res.status(500).json({ error: 'Failed to fetch order history' });
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
        dateOrdered: order.createdAt,
        services: order.Service.map((service) => ({
          name: service.name,
          price: service.price,
          quantity: service.OrderItem.quantity,
        })),
        total: order.total,
        status: order.status,
        hoursToComplete: order.hoursToComplete,
        pickupDateTime: order.pickupDateTime,
        customer: order.Customer
          ? {
              name: order.Customer.name,
              email: order.Customer.email,
            }
          : null,
      }));

      res.json(formattedOrders);
    } catch (error) {
      console.error("Error getting detailed order:", error);
      res
        .status(500)
        .json({ error: "An error occurred while getting detailed order" });
    }
  },

  setPickupDateTime: async (req, res) => {
    try {
      const { orderId } = req.params;
      const { pickupDateTime } = req.body;

      const order = await Order.findByPk(orderId);

      if (!order) {
        return res.status(404).json({ message: "Order not found" });
      }

      await order.update({ pickupDateTime: new Date(pickupDateTime) });

      res.json({ message: "Pickup date time set successfully" });
    } catch (error) {
      console.error("Error setting pickup date time:", error);
      res
        .status(500)
        .json({ error: "An error occurred while setting pickup date time" });
    }
  },
  getOrderDetailsAfterPayment: async (req, res) => {
    try {
      const { orderId } = req.params;
      const order = await Order.findByPk(orderId, {
        where: {
          id: orderId,
        },
        include: [
          { model: User, attributes: ["name"] },
          { model: Service, through: { attributes: ["quantity"] } },
          {
            model: Customer,
            attributes: ["name", "phone"],
          },
          {
            model: Address,
            attributes: ["street", "city", "state", "postalCode"],
          },
          {
            model: Service,
            through: { attributes: ["quantity"] },
          },
          {
            model: Payment,
            attributes: ["amount", "paymentMethod", "status"],
            order: [["createdAt", "DESC"]],
            limit: 1,
          },
        ],
      });

      if (!order) {
        return res.status(404).json({ message: "Order not found" });
      }

      const latestPayment = order.Payment[0];
      if (!latestPayment || latestPayment.status !== "complete") {
        return res.status(404).json({ message: "Payment not found" });
      }

      const orderDetails = {
        customerName: order.Customer.name,
        phoneNumber: order.Customer.phone,
        service: order.Service.map((service) => ({
          name: service.name,
          quantity: service.OrderItem.quantity,
        })),
        orderDate: order.createdAt,
        address: order.Address
          ? `${order.Address.street}, ${order.Address.city}, ${order.Address.state} ${order.Address.postalCode}`
          : "No address provided",
        urgencyType: order.urgencyType,
        total: order.total,
        paymentMethod: latestPayment.paymentMethod,
        status: latestPayment.status,
        hoursToComplete: order.hoursToComplete,
        pickupDateTime: order.pickupDateTime,
        assignedTo: Order.user ? order.user.name : "Not assigned",
      };
      res.json(orderDetails);
    } catch (error) {
      console.error("Error setting pickup date time:", error);
      res
        .status(500)
        .json({ error: "An error occurred while setting pickup date time" });
    }
  },

  getOnGoingOrders: async (req, res) => {
    try {
      const orders = await Order.findAll({
        where: {
          status: ["in process", "in process"],
        },
        include: [
          {
            model: Service,
            through: {
              attributes: ["quantity", "price"],
            },
          },
          {
            model: Customer,
            attributes: ["name", "phone"],
          },
        ],
        order: [["createdAt", "DESC"]],
      });

      const formattedOrders = orders.map((order) => ({
        id: order.id,
        serviceName: order.Service.map((service) => service.name).join(", "),
        duration: _calculateDuration,
        status: order.status,
        customerName: order.Customer.name,
        total: order.total,
      }));
      res.json(formattedOrders);
    } catch (error) {
      console.error("Error getting on going orders:", error);
      res
        .status(500)
        .json({ error: "An error occurred while getting on going orders" });
    }
  },
  getOrderDetails: async (req, res) => {
    try {
      const { orderId } = req.params;

      const order = await Order.findByPk(orderId, {
        include: [
          {
            model: Service,
            through: {
              attributes: ['quantity', 'price']
            }
          },
          {
            model: Customer,
            attributes: ['name', 'phone', 'email', 'deliveryType', 'latitude', 'longitude']
          },
          {
            model: Address,
            attributes: ['street', 'city', 'state', 'postal_code']
          }
        ]
      });

      if (!order) {
        return res.status(404).json({ error: 'Order not found' });
      }

      const orderDetails = {
        id: order.id,
        service: order.Services.map(s => s.name).join(', '),
        date: order.createdAt,
        price: order.Services.reduce((sum, service) => 
          sum + (service.OrderItem.quantity * service.OrderItem.price), 0
        ),
        pickupDateTime: order.pickupDateTime,
        isDelivery: order.Customer?.deliveryType === 'Express',
        status: order.status,
        customer: {
          name: order.Customer?.name,
          phone: order.Customer?.phone,
          email: order.Customer?.email,
          deliveryType: order.Customer?.deliveryType,
          location: order.Customer?.latitude && order.Customer?.longitude ? {
            latitude: order.Customer.latitude,
            longitude: order.Customer.longitude
          } : null
        },
        address: order.Address ? {
          street: order.Address.street,
          city: order.Address.city,
          state: order.Address.state,
          postalCode: order.Address.postal_code
        } : null,
        services: order.Services.map(service => ({
          name: service.name,
          quantity: service.OrderItem.quantity,
          price: service.OrderItem.price,
          subtotal: service.OrderItem.quantity * service.OrderItem.price
        }))
      };

      res.json(orderDetails);
    } catch (error) {
      console.error('Error fetching order details:', error);
      res.status(500).json({ error: 'Failed to fetch order details' });
    }
  },

  searchOrder: async (req, res) => {
    try{
      const { query } = req.query;
      const userId = req.user.id;

      const orders = await Order.findAll({
        where: {
          [Op.or]: [
            { UserId: userId }, 
            { "$Customer.UserId$": userId }],
            [Op.or] : [
              { 
                status: 
                { [Op.iLike]: `%${query}%` } 
              },
              {
                '$Services.name$': {[Op.iLike]: `%${query}%` },
              }
            ]
        },
        include: [
          {
            model: Service,
            through: {
              attributes: ["quantity", "price"],
            },
        } ,
        {
          model: Customer,
          attributes: ["name", "phone"],
        }
        ],
        order: [["createdAt", "DESC"]],
      });

      const formattedOrders = orders.map((order) => ({
        id: order.id,
        service: order.Service.map((service) => service.name).join(", "),
        dateTime: order.createdAt.toISOString(),
        status: order.status,
        total: order.Service.reduce((sum, service) => {
          return sum + (service.price * service.OrderItem.quantity);
        },0),
        customerName: order.Customer.name,
        customerPhone: order.Customer.phone,
        pickupDateTime: order.pickupDateTime,
      }));
      res.json(formattedOrders);

    }catch(error){
      console.error("Error searching order:", error);
      res
        .status(500)
        .json({ error: "An error occurred while searching order" });
    }
  },
  getActiveOrders: async (req, res) => {
    try {
      const userId = req.user.id;

      const orders = await Order.findAll({
        where: {
          status: ['pending', 'in process']
        },
        include: [
          {
            model: Service,
            through: {
              attributes: ['quantity', 'price']
            }
          },
          {
            model: Customer,
            attributes: ['name', 'phone', 'email', 'deliveryType']
          }
        ],
        order: [['createdAt', 'DESC']]
      });

      const formattedOrders = orders.map(order => ({
        id: order.id,
        service: order.Services.map(s => s.name).join(', '),
        date: order.createdAt,
        price: order.Services.reduce((sum, service) => 
          sum + (service.OrderItem.quantity * service.OrderItem.price), 0
        ),
        pickupDateTime: order.pickupDateTime || new Date(order.createdAt.getTime() + (24 * 60 * 60 * 1000)),
        isDelivery: order.Customer?.deliveryType === 'Express',
        status: order.status,
        customer: {
          name: order.Customer?.name || 'Unknown',
          phone: order.Customer?.phone || 'N/A',
          email: order.Customer?.email || 'N/A',
          deliveryType: order.Customer?.deliveryType || 'Standard'
        }
      }));

      res.json(formattedOrders);
    } catch (error) {
      console.error('Error fetching active orders:', error);
      res.status(500).json({ error: 'Failed to fetch active orders' });
    }
  },

  createOrder: async (req, res) => {
    try {
      const userId = req.user.id;
      const { services, pickupDateTime } = req.body;
  
      const order = await Order.create({
        UserId: userId,
        pickupDateTime: new Date(pickupDateTime),
        status: 'pending'
      });
  
      // Create order items for each service
      for (const serviceName of services) {
        const service = await Service.findOne({ where: { name: serviceName } });
        if (service) {
          await OrderItem.create({
            OrderId: order.id,
            ServiceId: service.id,
            quantity: 1, // Default quantity
            price: service.price
          });
        }
      }
  
      // Calculate total
      const total = await OrderItem.sum('price', { where: { OrderId: order.id } });
      await order.update({ total });
  
      const completeOrder = await Order.findOne({
        where: { id: order.id },
        include: [
          {
            model: Service,
            through: { attributes: ['quantity', 'price'] }
          }
        ]
      });
  
      res.status(201).json(completeOrder);
    } catch (error) {
      console.error('Error creating order:', error);
      res.status(500).json({ error: 'Failed to create order' });
    }
  }
};

function _calculateDuration(startDate, toHoursToComplete) {
  const endDate = new Date(startDate.getTime() + toHoursToComplete);
  const now = new Date();
  const hoursLeft = Math.ceil((endDate - now) / (1000 * 60 * 60));

  return hoursLeft > 0 ? `${hoursLeft} hours left` : "Overdue";
}

module.exports = orderController;
