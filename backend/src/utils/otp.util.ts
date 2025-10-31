import crypto from 'crypto';

export class OtpUtils {
  static generate(): string {
    return crypto.randomInt(100000, 999999).toString();
  }

  static getExpiryDate(minutes: number = 5): Date {
    return new Date(Date.now() + minutes * 60 * 1000);
  }

  static isExpired(expiryDate: Date): boolean {
    return new Date() > expiryDate;
  }
}
