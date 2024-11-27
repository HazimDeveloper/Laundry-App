const express = require('express');

const router = express.Router();

const orderController = require('../controllers/orderController');

const { authMiddleware, adminMiddleware } = require('../middleware/authMiddleware');

router.post('/', authMiddleware, orderController.createOrder);
router.get('/history/:customerId',authMiddleware,orderController.getOrderHistory);
router.patch('/:orderId',authMiddleware,orderController.updateOrderStatus); 
router.get('/detailed',authMiddleware,adminMiddleware,orderController.getDetailedOrder);
router.patch('/:orderId/pickup',authMiddleware,orderController.setPickupDateTime);
router.get('/:orderId/details-after-payment',authMiddleware,orderController.getOrderDetailsAfterPayment);   
router.get('/ongoing', authMiddleware,orderController.getOnGoingOrders);
router.get('/history',authMiddleware,orderController.getOrderHistory);
router.get('/history/:orderId', authMiddleware, orderController.getOrderDetails);
router.get('/search',authMiddleware,orderController.searchOrder);
router.get('/active', authMiddleware, orderController.getActiveOrders);
module.exports = router

