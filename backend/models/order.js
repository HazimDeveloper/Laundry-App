module.exports = (sequelize, DataTypes) => {
  const Order = sequelize.define('Order', {
    status: {
      type: DataTypes.ENUM('pending', 'in process', 'complete', 'cancelled'),
      defaultValue: 'pending'
    },
    total: {
      type: DataTypes.DECIMAL(10, 2),
      defaultValue: 0.00
    },
    hoursToComplete: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 24
    },
    pickupDateTime: {
      type: DataTypes.DATE,
      allowNull: true
    }
  }, {
    tableName: 'Orders'
  });

  Order.associate = function(models) {
    Order.belongsTo(models.User);
    Order.belongsToMany(models.Service, { through: models.OrderItem });
    Order.belongsTo(models.Address);  // Changed from hasMany
    Order.hasMany(models.Payment);
    Order.belongsTo(models.Customer);
  };

  return Order;
};