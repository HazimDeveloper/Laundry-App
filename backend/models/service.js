module.exports = (sequelize, DataTypes) => {
    const Service = sequelize.define('Service', {
      name: DataTypes.STRING,
      description: DataTypes.TEXT,
      price: DataTypes.DECIMAL
    }, {});
  
    Service.associate = function(models) {
      Service.belongsToMany(models.Order, { through: models.OrderItem });
    };
  
    return Service;
  };