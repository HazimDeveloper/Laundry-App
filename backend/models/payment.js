module.exports = (sequelize, DataTypes) => {
  const Payment = sequelize.define('Payment', {
    amount: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false
    },
    payment_method: {
      type: DataTypes.STRING,
      allowNull: false
    },
    transaction_id: {
      type: DataTypes.STRING,
      unique: true
    },
    status: {
      type: DataTypes.ENUM('pending', 'completed', 'failed'),
      defaultValue: 'pending'
    },
    timestamp: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW
    }
  }, {});

  Payment.associate = function(models) {
    Payment.belongsTo(models.Order);
  };

  return Payment;
};