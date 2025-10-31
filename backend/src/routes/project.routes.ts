import { Router } from 'express';
import { projectController } from '../controllers/project.controller';
import { authenticate } from '../middleware';

const router = Router();

// Public routes (no authentication required)
router.get('/', projectController.getAll); // Public marketplace listing
router.get('/:id', projectController.getById); // Public project details

// Protected routes (authentication required)
router.post('/', authenticate, projectController.create);
router.get('/my-projects', authenticate, projectController.getMyProjects);
router.put('/:id', authenticate, projectController.update);
router.delete('/:id', authenticate, projectController.delete);

export default router;
