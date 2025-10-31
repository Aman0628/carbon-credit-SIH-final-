import { db } from '../config';
import { PasswordUtils, OtpUtils } from '../utils';

export class SellerService {
  async findByEmail(email: string) {
    return db.seller.findUnique({
      where: { organization_email: email },
      select: {
        id: true,
        organization_email: true,
        organization_name: true,
        phone_no: true,
        password: true,
        otp_code: true,
        otp_expires_at: true,
        isVerified: true,
      },
    });
  }

  async create(data: {
    organization_email: string;
    organization_name: string;
    phone_no: string;
    password: string;
  }) {
    const hashedPassword = await PasswordUtils.hash(data.password);

    return db.seller.create({
      data: {
        organization_email: data.organization_email,
        organization_name: data.organization_name,
        phone_no: data.phone_no,
        password: hashedPassword,
      },
      select: {
        id: true,
        organization_email: true,
        organization_name: true,
        phone_no: true,
        isVerified: true,
      },
    });
  }

  async updateOtp(email: string, otp: string, expiresAt: Date) {
    return db.seller.update({
      where: { organization_email: email },
      data: {
        otp_code: otp,
        otp_expires_at: expiresAt,
      },
    });
  }

  async verifyOtp(
    email: string,
    providedOtp: string
  ): Promise<{ valid: boolean; message: string }> {
    const seller = await this.findByEmail(email);

    if (!seller || !seller.otp_code || !seller.otp_expires_at) {
      return { valid: false, message: 'OTP not found' };
    }

    if (seller.otp_code !== providedOtp) {
      return { valid: false, message: 'Invalid OTP' };
    }

    if (OtpUtils.isExpired(seller.otp_expires_at)) {
      return { valid: false, message: 'OTP has expired' };
    }

    // Mark as verified and clear OTP
    await db.seller.update({
      where: { organization_email: email },
      data: {
        isVerified: true,
        otp_code: null,
        otp_expires_at: null,
      },
    });

    return { valid: true, message: 'Email verified successfully' };
  }

  async verifyPassword(
    plainPassword: string,
    hashedPassword: string
  ): Promise<boolean> {
    return PasswordUtils.compare(plainPassword, hashedPassword);
  }

  async getDashboardStats(seller_id: string) {
    const [totalProjects, totalSales, totalRevenue] = await Promise.all([
      db.project.count({
        where: { seller_id },
      }),
      db.transaction.count({
        where: { seller_id, status: 'Success' },
      }),
      db.transaction.aggregate({
        where: { seller_id, status: 'Success' },
        _sum: { amount: true },
      }),
    ]);

    const recentSales = await db.transaction.findMany({
      where: { seller_id },
      take: 5,
      orderBy: { start_time: 'desc' },
      include: {
        buyer: {
          select: {
            organization_name: true,
          },
        },
      },
    });

    const projects = await db.project.findMany({
      where: { seller_id },
      orderBy: { project_no: 'desc' },
      take: 5,
    });

    return {
      totalProjects,
      totalSales,
      totalRevenue: totalRevenue._sum.amount || 0,
      recentSales,
      projects,
    };
  }
}

export const sellerService = new SellerService();
