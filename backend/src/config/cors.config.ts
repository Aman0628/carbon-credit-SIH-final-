import { CorsOptions } from 'cors';
import { isDevelopment } from './env.config';

export const corsOptions: CorsOptions = {
  origin: isDevelopment
    ? ['http://localhost:3000', 'http://localhost:4000']
    : process.env.FRONTEND_URL?.split(',') || [],
  credentials: true,
  optionsSuccessStatus: 200,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization'],
};
