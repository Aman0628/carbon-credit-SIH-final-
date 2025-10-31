import { Request } from 'express';

// Request DTOs (Data Transfer Objects)
export interface AdminSignupRequest {
  name: string;
  email: string;
  password: string;
  admin_key: string;
}

export interface AdminLoginRequest {
  email: string;
  password: string;
}

export interface BuyerSignupRequest {
  organization_type: string;
  organization_email: string;
  organization_name: string;
  phone_no: string;
  password: string;
}

export interface BuyerLoginRequest {
  email: string;
  password: string;
}

export interface SellerSignupRequest {
  organization_email: string;
  organization_name: string;
  phone_no: string;
  password: string;
}

export interface SellerLoginRequest {
  email: string;
  password: string;
}

export interface SendOtpRequest {
  email: string;
}

export interface VerifyOtpRequest {
  email: string;
  otp: string;
}

// Response DTOs
export interface AuthResponse {
  message: string;
  user: {
    id: string;
    email: string;
    name?: string;
    organization_name?: string;
  };
}

export interface MessageResponse {
  message: string;
}

export interface ErrorResponse {
  message: string;
  errors?: Array<{
    field: string;
    message: string;
  }>;
}

// JWT Payload
export interface JwtPayload {
  id: string;
  email: string;
  role: 'admin' | 'buyer' | 'seller';
  iat?: number;
  exp?: number;
}

// Extended Express Request with user
export interface AuthenticatedRequest extends Request {
  user?: JwtPayload;
}
