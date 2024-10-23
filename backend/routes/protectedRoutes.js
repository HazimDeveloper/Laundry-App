const express = require('express');

const router = express.Router();

const {authMiddleware, adminMiddleware} = require('../middleware/authMiddleware');

router.get('/profile' , authMiddleware, (req, res) => {
    res.json({ message: "Profile accessed", user : req.user })
})

router.get('/admin-dashboard', authMiddleware, adminMiddleware, (req, res) => {
    res.json({ message: "Admin dashboard accessed"})
})

module.exports = router