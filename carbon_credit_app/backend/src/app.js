const express = require('express');
const routes = require('./routes');

const app = express();

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api', routes);

// Basic route
app.get('/', (req, res) => {
  res.json({ 
    message: 'Carbon Trading Backend API',
    status: 'Server is running!'
  });
});

module.exports = app;