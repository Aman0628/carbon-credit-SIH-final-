import { db } from '../config';
import { PasswordUtils } from '../utils/password.util';

export const adminProfileService = {
  async getProfile(id: string) {
    const admin = await db.admin.findUnique({
      where: { id },
      select: {
        id: true,
        name: true,
        email: true,
        created_at: true,
      },
    });

    if (!admin) {
      throw new Error('Admin not found');
    }

    return admin;
  },

  async updateProfile(id: string, data: { name?: string; email?: string }) {
    if (data.email) {
      const existingAdmin = await db.admin.findFirst({
        where: {
          email: data.email,
          id: { not: id },
        },
      });

      if (existingAdmin) {
        throw new Error('Email already in use');
      }
    }

    const updatedAdmin = await db.admin.update({
      where: { id },
      data: {
        ...(data.name && { name: data.name }),
        ...(data.email && { email: data.email }),
      },
      select: {
        id: true,
        name: true,
        email: true,
        created_at: true,
      },
    });

    return updatedAdmin;
  },

  async changePassword(
    id: string,
    currentPassword: string,
    newPassword: string
  ) {
    const admin = await db.admin.findUnique({
      where: { id },
    });

    if (!admin) {
      throw new Error('Admin not found');
    }

    const isValid = await PasswordUtils.compare(
      currentPassword,
      admin.password
    );
    if (!isValid) {
      throw new Error('Current password is incorrect');
    }

    const hashedPassword = await PasswordUtils.hash(newPassword);

    await db.admin.update({
      where: { id },
      data: { password: hashedPassword },
    });

    return { message: 'Password changed successfully' };
  },
};
