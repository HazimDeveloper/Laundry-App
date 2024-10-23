module.exports = (sequelize, DataTypes) => {
  const User = sequelize.define('User', {
    name: {
      type: DataTypes.STRING,
      allowNull: false
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
      validate: {
        isEmail: true
      }
    },
    passwordHash: {
      type: DataTypes.STRING,
      allowNull: false
    },
    address: {
      type: DataTypes.STRING,
      allowNull: true
    },
    role: {
      type: DataTypes.STRING,
      defaultValue: 'customer',
      allowNull: false
    }
  });

  User.associate = function(models) {
    User.hasMany(models.Order);
  };

  // Add method to validate password if needed
  User.prototype.validPassword = async function(password) {
    return await bcrypt.compare(password, this.passwordHash);
  };

  return User;
};