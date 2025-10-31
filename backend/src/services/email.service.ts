import nodemailer from 'nodemailer';
import { env } from '../config';

export class EmailService {
  private transporter: nodemailer.Transporter;

  constructor() {
    this.transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: env.EMAIL_USER,
        pass: env.EMAIL_PASS,
      },
    });
  }

  async sendOtp(to: string, otp: string): Promise<boolean> {
    try {
      await this.transporter.sendMail({
        from: env.EMAIL_USER,
        to,
        subject: 'Your OTP Code - Carbon Credit Marketplace',
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #2c3e50;">Email Verification</h2>
            <p>Your OTP code for email verification is:</p>
            <div style="background-color: #f8f9fa; padding: 20px; text-align: center; font-size: 32px; font-weight: bold; letter-spacing: 5px; margin: 20px 0;">
              ${otp}
            </div>
            <p style="color: #7f8c8d;">This code will expire in 5 minutes.</p>
            <p style="color: #7f8c8d;">If you didn't request this code, please ignore this email.</p>
            <hr style="border: 1px solid #ecf0f1; margin: 20px 0;">
            <p style="color: #95a5a6; font-size: 12px;">Carbon Credit Marketplace - Secure Trading Platform</p>
          </div>
        `,
        text: `Your OTP for email verification is ${otp}. It expires in 5 minutes.`,
      });
      return true;
    } catch (error) {
      console.error('Email sending failed:', error);
      return false;
    }
  }

  async sendWelcomeEmail(
    to: string,
    name: string,
    role: string
  ): Promise<boolean> {
    try {
      await this.transporter.sendMail({
        from: env.EMAIL_USER,
        to,
        subject: 'Welcome to Carbon Credit Marketplace',
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #2c3e50;">Welcome, ${name}!</h2>
            <p>Your account as a <strong>${role}</strong> has been successfully created.</p>
            <p>You can now access all features of the Carbon Credit Marketplace.</p>
            <hr style="border: 1px solid #ecf0f1; margin: 20px 0;">
            <p style="color: #95a5a6; font-size: 12px;">Carbon Credit Marketplace</p>
          </div>
        `,
      });
      return true;
    } catch (error) {
      console.error('Welcome email failed:', error);
      return false;
    }
  }
}

export const emailService = new EmailService();
