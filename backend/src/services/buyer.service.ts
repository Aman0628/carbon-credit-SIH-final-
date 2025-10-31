import { db } from '../config';
import { PasswordUtils, OtpUtils } from '../utils';

export class BuyerService {
  async findByEmail(email: string) {
    return db.buyer.findUnique({
      where: { organization_email: email },
      select: {
        id: true,
        organization_type: true,
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
    organization_type: string;
    organization_email: string;
    organization_name: string;
    phone_no: string;
    password: string;
  }) {
    const hashedPassword = await PasswordUtils.hash(data.password);

    return db.buyer.create({
      data: {
        organization_type: data.organization_type,
        organization_email: data.organization_email,
        organization_name: data.organization_name,
        phone_no: data.phone_no,
        password: hashedPassword,
      },
      select: {
        id: true,
        organization_email: true,
        organization_name: true,
        organization_type: true,
        phone_no: true,
        isVerified: true,
      },
    });
  }

  async updateOtp(email: string, otp: string, expiresAt: Date) {
    return db.buyer.update({
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
    const buyer = await this.findByEmail(email);

    if (!buyer || !buyer.otp_code || !buyer.otp_expires_at) {
      return { valid: false, message: 'OTP not found' };
    }

    if (buyer.otp_code !== providedOtp) {
      return { valid: false, message: 'Invalid OTP' };
    }

    if (OtpUtils.isExpired(buyer.otp_expires_at)) {
      return { valid: false, message: 'OTP has expired' };
    }

    // Mark as verified and clear OTP
    await db.buyer.update({
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

  async getDashboardStats(buyer_id: string) {
    const [totalPurchases, totalSpent, pendingOrders] = await Promise.all([
      db.transaction.count({
        where: { buyer_id, status: 'Success' },
      }),
      db.transaction.aggregate({
        where: { buyer_id, status: 'Success' },
        _sum: { amount: true },
      }),
      db.transaction.count({
        where: { buyer_id, status: 'Proccessing' },
      }),
    ]);

    const recentTransactions = await db.transaction.findMany({
      where: { buyer_id },
      take: 5,
      orderBy: { start_time: 'desc' },
      include: {
        seller: {
          select: {
            organization_name: true,
          },
        },
      },
    });

    return {
      totalPurchases,
      totalSpent: totalSpent._sum.amount || 0,
      pendingOrders,
      recentTransactions,
    };
  }
}

export const buyerService = new BuyerService();
