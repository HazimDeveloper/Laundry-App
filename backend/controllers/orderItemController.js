// controllers/orderItemController.js
const { OrderItem, Order, Service } = require('../models');

const orderItemController = {
  getAllOrderItems: async (req, res) => {
    try {
      const orderItems = await OrderItem.findAll({
        include: [
          { model: Order },
          { model: Service }
        ]
      });
      
      res.json(orderItems);
    } catch (error) {
      console.error('Error retrieving order items:', error);
      res.status(500).json({ error: 'An error occurred while retrieving order items' });
    }
  },

  // You can add more controller methods here as needed
};

module.exports = orderItemController;