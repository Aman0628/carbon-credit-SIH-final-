import { Request, Response } from 'express';
import { projectService } from '../services/project.service';
import { ApiResponse } from '../utils';

export class ProjectController {
  async create(req: Request, res: Response) {
    try {
      const { project_name, project_no, authority } = req.body;
      const seller_id = (req as any).user.id;

      if (!project_name || !project_no) {
        return ApiResponse.badRequest(
          res,
          'Project name and number are required'
        );
      }

      const project = await projectService.create({
        project_name,
        project_no: parseInt(project_no),
        authority: authority || '',
        seller_id,
      });

      return ApiResponse.created(
        res,
        { project },
        'Project created successfully'
      );
    } catch (error) {
      console.error('Create project error:', error);
      return ApiResponse.internalError(res, 'Failed to create project');
    }
  }

  async getAll(req: Request, res: Response) {
    try {
      const { seller_id, search } = req.query;

      const projects = await projectService.findAll({
        seller_id: seller_id as string,
        search: search as string,
      });

      return ApiResponse.success(
        res,
        { projects },
        'Projects loaded successfully'
      );
    } catch (error) {
      console.error('Get projects error:', error);
      return ApiResponse.internalError(res, 'Failed to load projects');
    }
  }

  async getById(req: Request, res: Response) {
    try {
      const { id } = req.params;

      const project = await projectService.findById(id);

      if (!project) {
        return ApiResponse.notFound(res, 'Project not found');
      }

      return ApiResponse.success(
        res,
        { project },
        'Project loaded successfully'
      );
    } catch (error) {
      console.error('Get project error:', error);
      return ApiResponse.internalError(res, 'Failed to load project');
    }
  }

  async update(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const { project_name, authority } = req.body;
      const seller_id = (req as any).user.id;

      // Verify ownership
      const existingProject = await projectService.findById(id);
      if (!existingProject) {
        return ApiResponse.notFound(res, 'Project not found');
      }

      if (existingProject.seller_id !== seller_id) {
        return ApiResponse.forbidden(
          res,
          'You do not have permission to update this project'
        );
      }

      const project = await projectService.update(id, {
        project_name,
        authority,
      });

      return ApiResponse.success(
        res,
        { project },
        'Project updated successfully'
      );
    } catch (error) {
      console.error('Update project error:', error);
      return ApiResponse.internalError(res, 'Failed to update project');
    }
  }

  async delete(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const seller_id = (req as any).user.id;

      // Verify ownership
      const existingProject = await projectService.findById(id);
      if (!existingProject) {
        return ApiResponse.notFound(res, 'Project not found');
      }

      if (existingProject.seller_id !== seller_id) {
        return ApiResponse.forbidden(
          res,
          'You do not have permission to delete this project'
        );
      }

      await projectService.delete(id);

      return ApiResponse.success(res, null, 'Project deleted successfully');
    } catch (error) {
      console.error('Delete project error:', error);
      return ApiResponse.internalError(res, 'Failed to delete project');
    }
  }

  async getMyProjects(req: Request, res: Response) {
    try {
      const seller_id = (req as any).user.id;

      const projects = await projectService.getSellerProjects(seller_id);

      return ApiResponse.success(
        res,
        { projects },
        'Your projects loaded successfully'
      );
    } catch (error) {
      console.error('Get my projects error:', error);
      return ApiResponse.internalError(res, 'Failed to load your projects');
    }
  }
}

export const projectController = new ProjectController();
