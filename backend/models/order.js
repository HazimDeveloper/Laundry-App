module.exports = (sequelize, DataTypes) => {
    const Order = sequelize.define('Order', {
      status: DataTypes.ENUM('pending', 'in process', 'complete','cancelled'),
      defaultValue: 'pending',
    }, {
      total: DataTypes.DECIMAL(10,2),
      defaultValue: 0.00
    },{
      //check hours to complete order
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 24
    },{
      pickupDateTime: {
        type: DataTypes.DATE,
        allowNull: true
      },
      urgencyType: {
        type: DataTypes.ENUM('standard','immediate', 'urgent'),
        defaultValue: 'standard'
      },
      orderDate : {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
      }
    });
  
    Order.associate = function(models) {
      Order.belongsTo(models.User);
      Order.belongsToMany(models.Service, { through: models.OrderItem });
      Order.hasMany(models.Address);
      Order.hasMany(models.Payment);
      Order.belongsTo(models.Customer);
    };
  
    return Order;
  };