// controllers/customerController.js
const { Customer, Order, Address } = require("../models");

const customerController = {
  getAllCustomers: async (req, res) => {
    try {
      const customers = await Customer.findAll({
        include: [{ model: Order }, { model: Address }],
      });

      res.json(customers);
    } catch (error) {
      console.error("Error retrieving customers:", error);
      res
        .status(500)
        .json({ error: "An error occurred while retrieving customers" });
    }
  },

  updateLocation: async (req, res) => {
    try {
      const { customerId } = req.params;
      const { latitude, longitude } = req.body;

      const customer = await Customer.findByPk(customerId);

      if (!customer) {
        return res.status(404).json({ message: "Customer not found" });
      }

      await customer.update({ latitude, longitude });

      res.json({
        message: "Location updated successfully",
        customer: {
          id: customer.id,
          name: customer.name,
          latitude: customer.latitude,
          longitude: customer.longitude,
        },
      });
    } catch (error) {
      console.error("Error updating location:", error);
      res
        .status(500)
        .json({ error: "An error occurred while updating location" });
    }
  },

  updateDeliveryType: async (req, res) => {
    try {
      const { customerId } = req.params;
      const { deliveryType } = req.body;

      const customer = await Customer.findByPk(customerId);

      if(!customer){
        return res.status(404).json({ message: "Customer not found" });
      }

      if(!['pickup','delivery'].includes(deliveryType)){
        return res.status(400).json({ message: "Invalid delivery type" });
      }

      await customer.update({ deliveryType });

      res.json({
        message: "Delivery type updated successfully",
        customer:{
          id: customer.id,
          name: customer.name,
          latitude: customer.latitude,
          longitude: customer.longitude,
          deliveryType: customer.deliveryType
        }
      })
    } catch (error) {
      console.error("Error updating delivery type:", error);
      res
        .status(500)
        .json({ error: "An error occurred while updating delivery type" });
    }
  },
};

module.exports = customerController;
