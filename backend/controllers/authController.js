const { User } = require('../models');
const jwt = require('jsonwebtoken');

const authController = {
  register: async (req, res) => {
    try {
      const { name, email, password, address } = req.body;
      
      // Check if it's the admin email
      const role = email === 'admin@gmail.com' ? 'admin' : 'customer';

      const user = await User.create({
        name,
        email,
        passwordHash: password,
        address,
        role
      });

      const token = jwt.sign({ id: user.id, role: user.role }, process.env.JWT_SECRET, {
        expiresIn: '1d'
      });

      res.status(201).json({ 
        user: { 
          id: user.id, 
          name, 
          email, 
          address, 
          role 
        }, 
        token 
      });
    } catch (error) {
      console.error('Registration error:', error);
      res.status(400).json({ error: 'Registration failed' });
    }
  },


  login: async (req, res) => {
    try {
      const { email, password } = req.body;

      // Special case for admin
      if (email === 'admin@gmail.com' && password === 'admin') {
        const adminUser = await User.findOne({ where: { email: 'admin@gmail.com' } });
        
        if (!adminUser) {
          // If admin doesn't exist, create it
          const adminUser = await User.create({
            name: 'Admin',
            email: 'admin@gmail.com',
            passwordHash: 'admin',
            address: 'Admin Address',
            role: 'admin'
          });
        }

        const token = jwt.sign({ id: adminUser.id, role: 'admin' }, process.env.JWT_SECRET, {
          expiresIn: '1d'
        });

        return res.json({ 
          user: { 
            id: adminUser.id, 
            name: 'Admin', 
            email: 'admin@gmail.com', 
            address: adminUser.address, 
            role: 'admin' 
          }, 
          token 
        });
      }

      // Regular user login
      const user = await User.findOne({ where: { email } });

      // if (!user || !(await user.validPassword(password))) {
      //   return res.status(401).json({ error: 'Invalid credentials' });
      // }

      const token = jwt.sign({ id: user.id, role: user.role }, process.env.JWT_SECRET, {
        expiresIn: '1d'
      });

      res.json({ 
        user: { 
          id: user.id, 
          name: user.name, 
          email: user.email, 
          address: user.address, 
          role: user.role 
        }, 
        token 
      });
    } catch (error) {
      console.error('Login error:', error);
      res.status(500).json({ error: 'Login failed' });
    }
  }
};

module.exports = authController;