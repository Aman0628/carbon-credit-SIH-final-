import dotenv from 'dotenv';

dotenv.config();

interface EnvConfig {
  PORT: number;
  NODE_ENV: string;
  DATABASE_URL: string;
  JWT_SECRET: string;
  JWT_EXPIRES_IN: string;
  ADMIN_KEY: string;
  EMAIL_USER: string;
  EMAIL_PASS: string;
  COOKIE_MAX_AGE: number;
}

const getEnvVar = (key: string, defaultValue?: string): string => {
  const value = process.env[key] || defaultValue;
  if (!value) {
    throw new Error(`Missing environment variable: ${key}`);
  }
  return value;
};

export const env: EnvConfig = {
  PORT: parseInt(getEnvVar('PORT', '4000'), 10),
  NODE_ENV: getEnvVar('NODE_ENV', 'development'),
  DATABASE_URL: getEnvVar('DATABASE_URL'),
  JWT_SECRET: getEnvVar('JWT_SECRET'),
  JWT_EXPIRES_IN: getEnvVar('JWT_EXPIRES_IN', '1h'),
  ADMIN_KEY: getEnvVar('ADMIN_KEY'),
  EMAIL_USER: getEnvVar('EMAIL_USER'),
  EMAIL_PASS: getEnvVar('EMAIL_PASS'),
  COOKIE_MAX_AGE: 60 * 60 * 1000, // 1 hour in milliseconds
};

export const isDevelopment = env.NODE_ENV === 'development';
export const isProduction = env.NODE_ENV === 'production';
