import { Request, Response, NextFunction } from 'express';
import { Prisma } from '@prisma/client';
import { ZodError } from 'zod';
import { ApiResponse } from '../utils';
import { isDevelopment } from '../config';

export const errorHandler = (
  error: Error,
  req: Request,
  res: Response,
  _next: NextFunction
) => {
  console.error('Error:', error);

  // Prisma errors
  if (error instanceof Prisma.PrismaClientKnownRequestError) {
    switch (error.code) {
      case 'P2002':
        return ApiResponse.conflict(
          res,
          `Duplicate entry: ${error.meta?.target || 'field'} already exists`
        );
      case 'P2025':
        return ApiResponse.notFound(res, 'Record not found');
      case 'P2003':
        return ApiResponse.badRequest(res, 'Invalid reference');
      default:
        return ApiResponse.internalError(res, 'Database error occurred');
    }
  }

  // Zod validation errors
  if (error instanceof ZodError) {
    const errors = error.issues.map((err) => ({
      field: err.path.join('.'),
      message: err.message,
    }));
    return ApiResponse.badRequest(res, 'Validation failed', errors);
  }

  // JWT errors
  if (error.name === 'JsonWebTokenError') {
    return ApiResponse.unauthorized(res, 'Invalid token');
  }

  if (error.name === 'TokenExpiredError') {
    return ApiResponse.unauthorized(res, 'Token expired');
  }

  // Default error
  const message = isDevelopment ? error.message : 'Internal server error';
  return ApiResponse.internalError(res, message);
};
