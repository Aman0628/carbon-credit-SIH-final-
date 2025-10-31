import { Request, Response } from 'express';
import { adminService } from '../services';
import { ApiResponse, TokenUtils } from '../utils';
import { env } from '../config';
import { AdminSignupInput, AdminLoginInput } from '../schemas';

export class AdminController {
  async signup(req: Request, res: Response) {
    try {
      const { name, email, password, admin_key } = req.body as AdminSignupInput;

      // Validate admin key
      const isValidKey = await adminService.validateAdminKey(
        admin_key,
        env.ADMIN_KEY
      );
      if (!isValidKey) {
        return ApiResponse.forbidden(res, 'Invalid admin key');
      }

      // Check if admin already exists
      const existingAdmin = await adminService.findByEmail(email);
      if (existingAdmin) {
        return ApiResponse.conflict(
          res,
          'Admin already exists with this email'
        );
      }

      // Create admin
      const admin = await adminService.create({ name, email, password });

      return ApiResponse.created(
        res,
        { admin },
        'Admin account created successfully'
      );
    } catch (error) {
      console.error('Admin signup error:', error);
      return ApiResponse.internalError(res, 'Failed to create admin account');
    }
  }

  async login(req: Request, res: Response) {
    try {
      const { email, password } = req.body as AdminLoginInput;

      // Find admin
      const admin = await adminService.findByEmail(email);
      if (!admin) {
        return ApiResponse.notFound(res, 'Admin not found');
      }

      // Verify password
      const isPasswordValid = await adminService.verifyPassword(
        password,
        admin.password
      );
      if (!isPasswordValid) {
        return ApiResponse.unauthorized(res, 'Invalid credentials');
      }

      // Generate JWT token
      const token = TokenUtils.generate({
        id: admin.id,
        email: admin.email,
        role: 'admin',
      });

      // Set cookie
      res.cookie('auth_token', token, {
        httpOnly: true,
        secure: env.NODE_ENV === 'production',
        sameSite: 'lax', // Changed from 'strict' to 'lax' for cross-origin
        maxAge: env.COOKIE_MAX_AGE,
      });

      return ApiResponse.success(
        res,
        {
          token, // Also return token in response body
          admin: {
            id: admin.id,
            email: admin.email,
            name: admin.name,
          },
        },
        'Logged in successfully'
      );
    } catch (error) {
      console.error('Admin login error:', error);
      return ApiResponse.internalError(res, 'Login failed');
    }
  }

  async logout(req: Request, res: Response) {
    try {
      res.clearCookie('auth_token');
      return ApiResponse.success(res, null, 'Logged out successfully');
    } catch (error) {
      console.error('Admin logout error:', error);
      return ApiResponse.internalError(res, 'Logout failed');
    }
  }

  async getDashboard(req: Request, res: Response) {
    try {
      const stats = await adminService.getDashboardStats();
      return ApiResponse.success(res, stats, 'Dashboard stats loaded');
    } catch (error) {
      console.error('Admin dashboard error:', error);
      return ApiResponse.internalError(res, 'Failed to load dashboard');
    }
  }

  async getUsers(req: Request, res: Response) {
    try {
      const users = await adminService.getAllUsers();
      return ApiResponse.success(res, users, 'Users loaded successfully');
    } catch (error) {
      console.error('Get users error:', error);
      return ApiResponse.internalError(res, 'Failed to load users');
    }
  }

  async verifyUser(req: Request, res: Response) {
    try {
      const { userId, role } = req.body;

      if (!userId || !role || !['buyer', 'seller'].includes(role)) {
        return ApiResponse.badRequest(res, 'Invalid user ID or role');
      }

      await adminService.verifyUser(userId, role as 'buyer' | 'seller');
      return ApiResponse.success(res, null, 'User verified successfully');
    } catch (error) {
      console.error('Verify user error:', error);
      return ApiResponse.internalError(res, 'Failed to verify user');
    }
  }
}

export const adminController = new AdminController();
