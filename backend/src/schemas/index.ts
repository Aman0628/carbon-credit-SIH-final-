import { z } from 'zod';

// Admin Schemas
export const adminSignupSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters').max(256),
  email: z.string().email('Invalid email format').max(256),
  password: z
    .string()
    .min(6, 'Password must be at least 6 characters')
    .max(100),
  admin_key: z.string().min(1, 'Admin key is required'),
});

export const adminLoginSchema = z.object({
  email: z.string().email('Invalid email format'),
  password: z.string().min(1, 'Password is required'),
});

// Buyer Schemas
export const buyerSignupSchema = z.object({
  organization_type: z.string().min(1, 'Organization type is required'),
  organization_email: z.string().email('Invalid email format').max(256),
  organization_name: z
    .string()
    .min(2, 'Organization name must be at least 2 characters')
    .max(256),
  phone_no: z
    .string()
    .regex(/^\+?[\d\s-()]+$/, 'Invalid phone number format')
    .max(15),
  password: z
    .string()
    .min(6, 'Password must be at least 6 characters')
    .max(100),
});

export const buyerLoginSchema = z.object({
  email: z.string().email('Invalid email format'),
  password: z.string().min(1, 'Password is required'),
});

// Seller Schemas
export const sellerSignupSchema = z.object({
  organization_email: z.string().email('Invalid email format').max(256),
  organization_name: z
    .string()
    .min(2, 'Organization name must be at least 2 characters')
    .max(256),
  phone_no: z
    .string()
    .regex(/^\+?[\d\s-()]+$/, 'Invalid phone number format')
    .max(15),
  password: z
    .string()
    .min(6, 'Password must be at least 6 characters')
    .max(100),
});

export const sellerLoginSchema = z.object({
  email: z.string().email('Invalid email format'),
  password: z.string().min(1, 'Password is required'),
});

// OTP Schemas
export const sendOtpSchema = z.object({
  email: z.string().email('Invalid email format'),
});

export const verifyOtpSchema = z.object({
  email: z.string().email('Invalid email format'),
  otp: z.string().length(6, 'OTP must be exactly 6 digits'),
});

export type AdminSignupInput = z.infer<typeof adminSignupSchema>;
export type AdminLoginInput = z.infer<typeof adminLoginSchema>;
export type BuyerSignupInput = z.infer<typeof buyerSignupSchema>;
export type BuyerLoginInput = z.infer<typeof buyerLoginSchema>;
export type SellerSignupInput = z.infer<typeof sellerSignupSchema>;
export type SellerLoginInput = z.infer<typeof sellerLoginSchema>;
export type SendOtpInput = z.infer<typeof sendOtpSchema>;
export type VerifyOtpInput = z.infer<typeof verifyOtpSchema>;
