module.exports = (sequelize, DataTypes) => {
    const OrderItem = sequelize.define('OrderItem', {
      quantity: DataTypes.INTEGER,
      price: DataTypes.DECIMAL
    }, {});
  
    OrderItem.associate = function(models) {
      OrderItem.belongsTo(models.Service);
      OrderItem.belongsTo(models.Order);
    };
  
    return OrderItem;
  };