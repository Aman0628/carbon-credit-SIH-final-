// Common TypeScript types for the frontend

export interface User {
  id: string;
  email: string;
  name?: string;
  organization_name?: string;
}

export interface AuthResponse {
  message: string;
  user: User;
}

export interface ApiError {
  message: string;
  errors?: Array<{
    field: string;
    message: string;
  }>;
}

export interface ApiSuccessResponse<T = any> {
  success: true;
  message: string;
  data: T;
}

export interface ApiErrorResponse {
  success: false;
  message: string;
  errors?: any;
}

export type ApiResponse<T = any> = ApiSuccessResponse<T> | ApiErrorResponse;

export type Role = 'admin' | 'buyer' | 'seller';

export interface AdminSignupData {
  name: string;
  email: string;
  password: string;
  admin_key: string;
}

export interface BuyerSignupData {
  organization_type: string;
  organization_email: string;
  organization_name: string;
  phone_no: string;
  password: string;
}

export interface SellerSignupData {
  organization_email: string;
  organization_name: string;
  phone_no: string;
  password: string;
}

export interface LoginData {
  email: string;
  password: string;
}

export interface OtpData {
  email: string;
  otp: string;
}
