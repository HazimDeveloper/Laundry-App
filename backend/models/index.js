// models/index.js
const { sequelize, DataTypes } = require('../database');

const User = require('./user')(sequelize, DataTypes);
const Address = require('./address')(sequelize, DataTypes);
const Customer = require('./customer')(sequelize, DataTypes);
const Order = require('./order')(sequelize, DataTypes);
const OrderItem = require('./orderItem')(sequelize, DataTypes);
const Payment = require('./payment')(sequelize, DataTypes);
const Service = require('./service')(sequelize, DataTypes);

// Set up associations
Object.values(sequelize.models).forEach(model => {
  if (typeof model.associate === 'function') {
    model.associate(sequelize.models);
  }
});

module.exports = {
  sequelize,
  User,
  Address,
  Customer,
  Order,
  OrderItem,
  Payment,
  Service
};