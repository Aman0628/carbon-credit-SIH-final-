const express = require('express');
const router = express.Router();

// Import route modules
// const authRoutes = require('./auth');
// const marketplaceRoutes = require('./marketplace');
// const userRoutes = require('./user');

// Use routes
// router.use('/auth', authRoutes);
// router.use('/marketplace', marketplaceRoutes);
// router.use('/users', userRoutes);

// Default API route
router.get('/', (req, res) => {
  res.json({
    message: 'Carbon Trading API',
    version: '1.0.0',
    endpoints: {
      // auth: '/api/auth',
      // marketplace: '/api/marketplace',
      // users: '/api/users'
    }
  });
});

module.exports = router;