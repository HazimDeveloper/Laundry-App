const express = require("express");
const cors = require("cors");
const db = require("./models");
const orderItemRoutes = require("./routes/orderItemRoutes");
const customerRoutes = require("./routes/customerRoutes");
const authRoutes = require("./routes/authRoutes");
const protectedRoutes = require("./routes/protectedRoutes");
const orderRoutes = require("./routes/orderRoutes");
const otpRoutes = require("./routes/otpRoutes");
const serviceRoutes = require('./routes/serviceRoutes');
require("dotenv").config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check endpoint
app.get('/', (req, res) => {
  res.status(200).json({ status: 'Server is running' });
});

app.get('/test', (req, res) => {
  res.json({ message: 'Server is reachable' });
});

// Routes
app.use("/api/order-items", orderItemRoutes);
app.use("/api/customers", customerRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/", protectedRoutes);
app.use("/api/order", orderRoutes);  // Fixed: added missing forward slash
app.use("/api/otp", otpRoutes);
app.use('/api/services',serviceRoutes)
// Database connection and sync
async function initializeDatabase() {
  try {
    await db.sequelize.authenticate();
    console.log("Connection to the database has been established successfully.");
    await db.sequelize.sync({ force: false });
    console.log("Database synchronized successfully.");
  } catch (error) {
    console.error("Unable to connect to the database:", error);
    process.exit(1);
  }
}

// Initialize database and start server
initializeDatabase().then(() => {
  app.listen(PORT, '0.0.0.0', () => {  // Added '0.0.0.0' to allow external connections
    console.log(`Server is running on port ${PORT}`);
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something broke!' });
});

module.exports = app;