module.exports = (sequelize, DataTypes) => {
  const Customer = sequelize.define(
    "Customer",
    {
      name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      phone: DataTypes.STRING,
      email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
        validate: {
          isEmail: true,
        },
      },
      latitude: {
        type: DataTypes.FLOAT,
        allowNull: true,
        validate: {
          min: -90,
          max: 90,
        },
      },
      longitude: {
        type: DataTypes.FLOAT,
        allowNull: true,
        validate: {
          min: -180,
          max: 180,
        },
      },
      deliveryType: {
        type: DataTypes.ENUM("Standard", "Express"),
        allowNull: false,
        defaultValue: "Standard",
      },
    },
    {}
  );

  Customer.associate = function (models) {
    Customer.hasMany(models.Order);
    Customer.hasMany(models.Address);
  };

  return Customer;
};
