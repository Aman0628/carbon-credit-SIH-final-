import { db } from '../config';
import { PasswordUtils } from '../utils';

export class AdminService {
  async findByEmail(email: string) {
    return db.admin.findUnique({
      where: { email },
      select: {
        id: true,
        name: true,
        email: true,
        password: true,
        created_at: true,
      },
    });
  }

  async create(data: { name: string; email: string; password: string }) {
    const hashedPassword = await PasswordUtils.hash(data.password);

    return db.admin.create({
      data: {
        name: data.name,
        email: data.email,
        password: hashedPassword,
      },
      select: {
        id: true,
        name: true,
        email: true,
        created_at: true,
      },
    });
  }

  async validateAdminKey(
    providedKey: string,
    requiredKey: string
  ): Promise<boolean> {
    return providedKey === requiredKey;
  }

  async verifyPassword(
    plainPassword: string,
    hashedPassword: string
  ): Promise<boolean> {
    return PasswordUtils.compare(plainPassword, hashedPassword);
  }

  async getDashboardStats() {
    const [totalBuyers, totalSellers, totalProjects, totalTransactions] =
      await Promise.all([
        db.buyer.count(),
        db.seller.count(),
        db.project.count(),
        db.transaction.count(),
      ]);

    const recentTransactions = await db.transaction.findMany({
      take: 5,
      orderBy: { start_time: 'desc' },
      include: {
        buyer: { select: { organization_name: true } },
        seller: { select: { organization_name: true } },
      },
    });

    const pendingVerifications = await db.buyer.count({
      where: { isVerified: false },
    });

    return {
      totalBuyers,
      totalSellers,
      totalProjects,
      totalTransactions,
      pendingVerifications,
      recentTransactions,
    };
  }

  async getAllUsers() {
    const buyers = await db.buyer.findMany({
      select: {
        id: true,
        organization_name: true,
        organization_email: true,
        organization_type: true,
        isVerified: true,
        phone_no: true,
      },
    });

    const sellers = await db.seller.findMany({
      select: {
        id: true,
        organization_name: true,
        organization_email: true,
        isVerified: true,
        phone_no: true,
      },
    });

    return { buyers, sellers };
  }

  async verifyUser(userId: string, role: 'buyer' | 'seller') {
    if (role === 'buyer') {
      return db.buyer.update({
        where: { id: userId },
        data: { isVerified: true },
      });
    } else {
      return db.seller.update({
        where: { id: userId },
        data: { isVerified: true },
      });
    }
  }
}

export const adminService = new AdminService();
