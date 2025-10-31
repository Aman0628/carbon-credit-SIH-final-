// HTTP Status Codes
export const HTTP_STATUS = {
  OK: 200,
  CREATED: 201,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  CONFLICT: 409,
  INTERNAL_SERVER_ERROR: 500,
} as const;

// Success Messages
export const SUCCESS_MESSAGES = {
  ADMIN_CREATED: 'Admin account created successfully',
  BUYER_CREATED: 'Buyer account created successfully',
  SELLER_CREATED: 'Seller account created successfully',
  LOGIN_SUCCESS: 'Logged in successfully',
  LOGOUT_SUCCESS: 'Logged out successfully',
  OTP_SENT: 'OTP sent successfully to your email',
  EMAIL_VERIFIED: 'Email verified successfully',
} as const;

// Error Messages
export const ERROR_MESSAGES = {
  INVALID_ADMIN_KEY: 'Invalid admin key',
  ADMIN_EXISTS: 'Admin already exists with this email',
  BUYER_EXISTS: 'Buyer already exists with this email',
  SELLER_EXISTS: 'Seller already exists with this email',
  USER_NOT_FOUND: 'User not found',
  INVALID_CREDENTIALS: 'Invalid credentials',
  INVALID_OTP: 'Invalid or expired OTP',
  OTP_NOT_FOUND: 'OTP not found',
  AUTHENTICATION_REQUIRED: 'Authentication required',
  ACCESS_DENIED: 'Access denied',
  VALIDATION_FAILED: 'Validation failed',
  INTERNAL_ERROR: 'Internal server error',
} as const;

// Time Constants
export const TIME = {
  OTP_EXPIRY_MINUTES: 5,
  JWT_EXPIRY: '1h',
  COOKIE_MAX_AGE: 60 * 60 * 1000, // 1 hour in milliseconds
} as const;

// Roles
export const ROLES = {
  ADMIN: 'admin',
  BUYER: 'buyer',
  SELLER: 'seller',
} as const;

export type Role = (typeof ROLES)[keyof typeof ROLES];
