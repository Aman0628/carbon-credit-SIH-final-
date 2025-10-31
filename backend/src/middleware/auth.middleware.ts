import { Request, Response, NextFunction } from 'express';
import { TokenUtils, ApiResponse } from '../utils';
import { JwtPayload } from '../types';

// Extend Express Request type
/* eslint-disable @typescript-eslint/no-namespace */
declare global {
  namespace Express {
    interface Request {
      user?: JwtPayload;
    }
  }
}
/* eslint-enable @typescript-eslint/no-namespace */

export const authenticate = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const token = req.cookies.auth_token;

    if (!token) {
      return ApiResponse.unauthorized(res, 'Authentication required');
    }

    const decoded = TokenUtils.verify(token);
    req.user = decoded;

    next();
  } catch {
    return ApiResponse.unauthorized(res, 'Invalid or expired token');
  }
};

// Role-based authorization middleware
export const authorize = (...roles: Array<'admin' | 'buyer' | 'seller'>) => {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      return ApiResponse.unauthorized(res, 'Authentication required');
    }

    if (!roles.includes(req.user.role)) {
      return ApiResponse.forbidden(res, 'Access denied');
    }

    next();
  };
};
