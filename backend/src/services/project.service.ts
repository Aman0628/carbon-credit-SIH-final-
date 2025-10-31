import { db } from '../config';

export class ProjectService {
  async create(data: {
    project_name: string;
    project_no: number;
    authority: string;
    seller_id: string;
  }) {
    return db.project.create({
      data,
      include: {
        seller: {
          select: {
            id: true,
            organization_name: true,
            organization_email: true,
          },
        },
      },
    });
  }

  async findById(id: string) {
    return db.project.findUnique({
      where: { id },
      include: {
        seller: {
          select: {
            id: true,
            organization_name: true,
            organization_email: true,
            isVerified: true,
          },
        },
      },
    });
  }

  async findAll(filters?: { seller_id?: string; search?: string }) {
    const where: any = {};

    if (filters?.seller_id) {
      where.seller_id = filters.seller_id;
    }

    if (filters?.search) {
      where.OR = [
        { project_name: { contains: filters.search, mode: 'insensitive' } },
        { authority: { contains: filters.search, mode: 'insensitive' } },
      ];
    }

    return db.project.findMany({
      where,
      include: {
        seller: {
          select: {
            id: true,
            organization_name: true,
            organization_email: true,
            isVerified: true,
          },
        },
      },
      orderBy: { project_no: 'desc' },
    });
  }

  async update(
    id: string,
    data: {
      project_name?: string;
      authority?: string;
    }
  ) {
    return db.project.update({
      where: { id },
      data,
      include: {
        seller: {
          select: {
            id: true,
            organization_name: true,
            organization_email: true,
          },
        },
      },
    });
  }

  async delete(id: string) {
    return db.project.delete({
      where: { id },
    });
  }

  async getSellerProjects(seller_id: string) {
    return db.project.findMany({
      where: { seller_id },
      orderBy: { project_no: 'desc' },
    });
  }
}

export const projectService = new ProjectService();
