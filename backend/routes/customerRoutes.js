const express = require('express');
const router = express.Router();

const customerController = require('../controllers/customerController');
const { authMiddleware, adminMiddleware } = require('../middleware/authMiddleware');
router.get('/', customerController.getAllCustomers);    
router.patch('/:customerId/location',authMiddleware, customerController.updateLocation);
router.patch('/:customerId/delivery-type',authMiddleware, customerController.updateDeliveryType);
module.exports = router;





