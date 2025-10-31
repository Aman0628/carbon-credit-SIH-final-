import express from 'express';
import cors from 'cors';
import cookieParser from 'cookie-parser';
import { env, corsOptions } from './config';
import routes from './routes';
import { errorHandler, requestLogger } from './middleware';

const app = express();

// Middleware
app.use(requestLogger);
app.use(cors(corsOptions));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());

// API Routes
app.use('/api/v1', routes);

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'Carbon Credit Marketplace API',
    version: '1.0.0',
    endpoints: {
      health: '/api/v1/health',
      admin: '/api/v1/admin',
      buyer: '/api/v1/buyer',
      seller: '/api/v1/seller',
    },
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found',
    path: req.path,
  });
});

// Error handler (must be last)
app.use(errorHandler);

// Start server
app.listen(env.PORT, () => {
  console.log(`
╔══════════════════════════════════════════╗
║  Carbon Credit Marketplace API           ║
║  Server running on port ${env.PORT}      ║
║  Environment: ${env.NODE_ENV.padEnd(20)} ║
║  URL: http://localhost:${env.PORT}       ║
╚══════════════════════════════════════════╝
  `);
});
