import { db } from '../config';
import { PasswordUtils } from '../utils/password.util';

export const buyerProfileService = {
  async getProfile(id: string) {
    const buyer = await db.buyer.findUnique({
      where: { id },
      select: {
        id: true,
        organization_name: true,
        organization_email: true,
        organization_type: true,
        phone_no: true,
        isVerified: true,
        pan_no: true,
        aadhar_no: true,
        gst_no: true,
        registration_no: true,
        address: true,
      },
    });

    if (!buyer) {
      throw new Error('Buyer not found');
    }

    return buyer;
  },

  async updateProfile(
    id: string,
    data: {
      organization_name?: string;
      organization_email?: string;
      organization_type?: string;
      phone_no?: string;
      pan_no?: string;
      aadhar_no?: number;
      gst_no?: string;
      registration_no?: string;
      address?: string;
    }
  ) {
    if (data.organization_email) {
      const existing = await db.buyer.findFirst({
        where: {
          organization_email: data.organization_email,
          id: { not: id },
        },
      });

      if (existing) {
        throw new Error('Email already in use');
      }
    }

    const updatedBuyer = await db.buyer.update({
      where: { id },
      data,
      select: {
        id: true,
        organization_name: true,
        organization_email: true,
        organization_type: true,
        phone_no: true,
        isVerified: true,
        pan_no: true,
        aadhar_no: true,
        gst_no: true,
        registration_no: true,
        address: true,
      },
    });

    return updatedBuyer;
  },

  async changePassword(
    id: string,
    currentPassword: string,
    newPassword: string
  ) {
    const buyer = await db.buyer.findUnique({
      where: { id },
    });

    if (!buyer) {
      throw new Error('Buyer not found');
    }

    const isValid = await PasswordUtils.compare(
      currentPassword,
      buyer.password
    );
    if (!isValid) {
      throw new Error('Current password is incorrect');
    }

    const hashedPassword = await PasswordUtils.hash(newPassword);

    await db.buyer.update({
      where: { id },
      data: { password: hashedPassword },
    });

    return { message: 'Password changed successfully' };
  },
};
