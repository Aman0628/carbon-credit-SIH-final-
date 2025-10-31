import { Router } from 'express';
import { adminController } from '../controllers';
import { adminProfileController } from '../controllers/adminProfile.controller';
import { validate, authenticate } from '../middleware';
import { adminSignupSchema, adminLoginSchema } from '../schemas';

const router = Router();

// Public routes
router.post('/signup', validate(adminSignupSchema), adminController.signup);
router.post('/login', validate(adminLoginSchema), adminController.login);

// Protected routes
router.use(authenticate);
router.get('/dashboard', adminController.getDashboard);
router.get('/users', adminController.getUsers);
router.post('/verify-user', adminController.verifyUser);
router.post('/logout', adminController.logout);

// Profile routes
router.get('/profile', adminProfileController.getProfile);
router.put('/profile', adminProfileController.updateProfile);
router.post('/profile/change-password', adminProfileController.changePassword);

export default router;
