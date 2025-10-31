import { db } from '../config';
import { PasswordUtils } from '../utils/password.util';

export const sellerProfileService = {
  async getProfile(id: string) {
    const seller = await db.seller.findUnique({
      where: { id },
      select: {
        id: true,
        organization_name: true,
        organization_email: true,
        phone_no: true,
        isVerified: true,
        pan_no: true,
        aadhar_no: true,
        certificate_standard: true,
        address: true,
      },
    });

    if (!seller) {
      throw new Error('Seller not found');
    }

    return seller;
  },

  async updateProfile(
    id: string,
    data: {
      organization_name?: string;
      organization_email?: string;
      phone_no?: string;
      pan_no?: string;
      aadhar_no?: number;
      certificate_standard?: string;
      address?: string;
    }
  ) {
    if (data.organization_email) {
      const existing = await db.seller.findFirst({
        where: {
          organization_email: data.organization_email,
          id: { not: id },
        },
      });

      if (existing) {
        throw new Error('Email already in use');
      }
    }

    const updatedSeller = await db.seller.update({
      where: { id },
      data,
      select: {
        id: true,
        organization_name: true,
        organization_email: true,
        phone_no: true,
        isVerified: true,
        pan_no: true,
        aadhar_no: true,
        certificate_standard: true,
        address: true,
      },
    });

    return updatedSeller;
  },

  async changePassword(
    id: string,
    currentPassword: string,
    newPassword: string
  ) {
    const seller = await db.seller.findUnique({
      where: { id },
    });

    if (!seller) {
      throw new Error('Seller not found');
    }

    const isValid = await PasswordUtils.compare(
      currentPassword,
      seller.password
    );
    if (!isValid) {
      throw new Error('Current password is incorrect');
    }

    const hashedPassword = await PasswordUtils.hash(newPassword);

    await db.seller.update({
      where: { id },
      data: { password: hashedPassword },
    });

    return { message: 'Password changed successfully' };
  },
};
