// routes/orderItemRoutes.js
const express = require('express');
const router = express.Router();
const orderItemController = require('../controllers/orderItemController');

router.get('/', orderItemController.getAllOrderItems);

// You can add more routes here as needed

module.exports = router;