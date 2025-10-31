export * from './auth.middleware';
export * from './validate.middleware';
export * from './errorHandler.middleware';
export * from './logger.middleware';

// Keep old export for backward compatibility (will be removed after refactor)
export { authenticate as authMiddleware } from './auth.middleware';
