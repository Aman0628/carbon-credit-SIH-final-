import { Request, Response } from 'express';
import { sellerService, emailService } from '../services';
import { ApiResponse, TokenUtils, OtpUtils } from '../utils';
import { env } from '../config';
import { AuthenticatedRequest } from '../types';
import {
  SellerSignupInput,
  SellerLoginInput,
  SendOtpInput,
  VerifyOtpInput,
} from '../schemas';

export class SellerController {
  async signup(req: Request, res: Response) {
    try {
      const data = req.body as SellerSignupInput;

      // Check if seller already exists
      const existingSeller = await sellerService.findByEmail(
        data.organization_email
      );
      if (existingSeller) {
        return ApiResponse.conflict(
          res,
          'Seller already exists with this email'
        );
      }

      // Create seller
      const seller = await sellerService.create(data);

      return ApiResponse.created(
        res,
        { seller },
        'Seller account created successfully'
      );
    } catch (error) {
      console.error('Seller signup error:', error);

      // Handle Prisma unique constraint violation
      if (error && typeof error === 'object' && 'code' in error) {
        if (error.code === 'P2002') {
          return ApiResponse.conflict(res, 'Organization name already exists');
        }
      }

      return ApiResponse.internalError(res, 'Failed to create seller account');
    }
  }

  async login(req: Request, res: Response) {
    try {
      const { email, password } = req.body as SellerLoginInput;

      // Find seller
      const seller = await sellerService.findByEmail(email);
      if (!seller) {
        return ApiResponse.notFound(res, 'Seller not found');
      }

      // Verify password
      const isPasswordValid = await sellerService.verifyPassword(
        password,
        seller.password
      );
      if (!isPasswordValid) {
        return ApiResponse.unauthorized(res, 'Invalid credentials');
      }

      // Generate JWT token
      const token = TokenUtils.generate({
        id: seller.id,
        email: seller.organization_email,
        role: 'seller',
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
          seller: {
            id: seller.id,
            email: seller.organization_email,
            organization_name: seller.organization_name,
          },
        },
        'Logged in successfully'
      );
    } catch (error) {
      console.error('Seller login error:', error);
      return ApiResponse.internalError(res, 'Login failed');
    }
  }

  async sendOtp(req: Request, res: Response) {
    try {
      const { email } = req.body as SendOtpInput;

      // Check if seller exists
      const seller = await sellerService.findByEmail(email);
      if (!seller) {
        return ApiResponse.notFound(res, 'Seller not found');
      }

      // Generate OTP
      const otp = OtpUtils.generate();
      const expiresAt = OtpUtils.getExpiryDate(5); // 5 minutes

      // Update seller with OTP
      await sellerService.updateOtp(email, otp, expiresAt);

      // Send OTP via email
      const emailSent = await emailService.sendOtp(email, otp);
      if (!emailSent) {
        return ApiResponse.internalError(res, 'Failed to send OTP email');
      }

      return ApiResponse.success(
        res,
        null,
        'OTP sent successfully to your email'
      );
    } catch (error) {
      console.error('Seller send OTP error:', error);
      return ApiResponse.internalError(res, 'Failed to send OTP');
    }
  }

  async verifyOtp(req: Request, res: Response) {
    try {
      const { email, otp } = req.body as VerifyOtpInput;

      // Verify OTP
      const result = await sellerService.verifyOtp(email, otp);

      if (!result.valid) {
        return ApiResponse.badRequest(res, result.message);
      }

      return ApiResponse.success(res, null, result.message);
    } catch (error) {
      console.error('Seller verify OTP error:', error);
      return ApiResponse.internalError(res, 'Failed to verify OTP');
    }
  }

  async logout(req: Request, res: Response) {
    try {
      res.clearCookie('auth_token');
      return ApiResponse.success(res, null, 'Logged out successfully');
    } catch (error) {
      console.error('Seller logout error:', error);
      return ApiResponse.internalError(res, 'Logout failed');
    }
  }

  async getDashboard(req: Request, res: Response) {
    try {
      const seller_id = (req as AuthenticatedRequest).user?.id;
      if (!seller_id) {
        return ApiResponse.unauthorized(res, 'User not authenticated');
      }
      const stats = await sellerService.getDashboardStats(seller_id);
      return ApiResponse.success(res, stats, 'Dashboard stats loaded');
    } catch (error) {
      console.error('Seller dashboard error:', error);
      return ApiResponse.internalError(res, 'Failed to load dashboard');
    }
  }
}

export const sellerController = new SellerController();
