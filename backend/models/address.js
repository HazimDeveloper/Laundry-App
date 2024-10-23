module.exports = (sequelize, DataTypes) => {
  const Address = sequelize.define('Address', {
    street: {
      type: DataTypes.STRING,
      allowNull: false
    },
    city: {
      type: DataTypes.STRING,
      allowNull: false
    },
    state: {
      type: DataTypes.STRING,
      allowNull: false
    },
    postal_code: {
      type: DataTypes.STRING,
      allowNull: false
    },
    is_default: {
      type: DataTypes.BOOLEAN,
      defaultValue: false
    }
  }, {});

  Address.associate = function(models) {
    Address.belongsTo(models.Customer);
  };

  return Address;
};