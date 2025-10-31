import { Request, Response } from 'express';
import { buyerService, emailService } from '../services';
import { ApiResponse, TokenUtils, OtpUtils } from '../utils';
import { env } from '../config';
import { AuthenticatedRequest } from '../types';
import {
  BuyerSignupInput,
  BuyerLoginInput,
  SendOtpInput,
  VerifyOtpInput,
} from '../schemas';

export class BuyerController {
  async signup(req: Request, res: Response) {
    try {
      const data = req.body as BuyerSignupInput;

      // Check if buyer already exists
      const existingBuyer = await buyerService.findByEmail(
        data.organization_email
      );
      if (existingBuyer) {
        return ApiResponse.conflict(
          res,
          'Buyer already exists with this email'
        );
      }

      // Create buyer
      const buyer = await buyerService.create(data);

      return ApiResponse.created(
        res,
        { buyer },
        'Buyer account created successfully'
      );
    } catch (error) {
      console.error('Buyer signup error:', error);

      // Handle Prisma unique constraint violation
      if (error && typeof error === 'object' && 'code' in error) {
        if (error.code === 'P2002') {
          return ApiResponse.conflict(res, 'Organization name already exists');
        }
      }

      return ApiResponse.internalError(res, 'Failed to create buyer account');
    }
  }

  async login(req: Request, res: Response) {
    try {
      const { email, password } = req.body as BuyerLoginInput;

      // Find buyer
      const buyer = await buyerService.findByEmail(email);
      if (!buyer) {
        return ApiResponse.notFound(res, 'Buyer not found');
      }

      // Verify password
      const isPasswordValid = await buyerService.verifyPassword(
        password,
        buyer.password
      );
      if (!isPasswordValid) {
        return ApiResponse.unauthorized(res, 'Invalid credentials');
      }

      // Generate JWT token
      const token = TokenUtils.generate({
        id: buyer.id,
        email: buyer.organization_email,
        role: 'buyer',
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
          buyer: {
            id: buyer.id,
            email: buyer.organization_email,
            organization_name: buyer.organization_name,
          },
        },
        'Logged in successfully'
      );
    } catch (error) {
      console.error('Buyer login error:', error);
      return ApiResponse.internalError(res, 'Login failed');
    }
  }

  async sendOtp(req: Request, res: Response) {
    try {
      const { email } = req.body as SendOtpInput;

      // Check if buyer exists
      const buyer = await buyerService.findByEmail(email);
      if (!buyer) {
        return ApiResponse.notFound(res, 'Buyer not found');
      }

      // Generate OTP
      const otp = OtpUtils.generate();
      const expiresAt = OtpUtils.getExpiryDate(5); // 5 minutes

      // Update buyer with OTP
      await buyerService.updateOtp(email, otp, expiresAt);

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
      console.error('Buyer send OTP error:', error);
      return ApiResponse.internalError(res, 'Failed to send OTP');
    }
  }

  async verifyOtp(req: Request, res: Response) {
    try {
      const { email, otp } = req.body as VerifyOtpInput;

      // Verify OTP
      const result = await buyerService.verifyOtp(email, otp);

      if (!result.valid) {
        return ApiResponse.badRequest(res, result.message);
      }

      return ApiResponse.success(res, null, result.message);
    } catch (error) {
      console.error('Buyer verify OTP error:', error);
      return ApiResponse.internalError(res, 'Failed to verify OTP');
    }
  }

  async logout(req: Request, res: Response) {
    try {
      res.clearCookie('auth_token');
      return ApiResponse.success(res, null, 'Logged out successfully');
    } catch (error) {
      console.error('Buyer logout error:', error);
      return ApiResponse.internalError(res, 'Logout failed');
    }
  }

  async getDashboard(req: Request, res: Response) {
    try {
      const buyer_id = (req as AuthenticatedRequest).user?.id;
      if (!buyer_id) {
        return ApiResponse.unauthorized(res, 'User not authenticated');
      }
      const stats = await buyerService.getDashboardStats(buyer_id);
      return ApiResponse.success(res, stats, 'Dashboard stats loaded');
    } catch (error) {
      console.error('Buyer dashboard error:', error);
      return ApiResponse.internalError(res, 'Failed to load dashboard');
    }
  }
}

export const buyerController = new BuyerController();
