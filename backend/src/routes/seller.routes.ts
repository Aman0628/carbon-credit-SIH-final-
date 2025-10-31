import { Router } from 'express';
import { sellerController } from '../controllers';
import { sellerProfileController } from '../controllers/sellerProfile.controller';
import { validate, authenticate } from '../middleware';
import {
  sellerSignupSchema,
  sellerLoginSchema,
  sendOtpSchema,
  verifyOtpSchema,
} from '../schemas';

const router = Router();

// Public routes
router.post('/signup', validate(sellerSignupSchema), sellerController.signup);
router.post('/login', validate(sellerLoginSchema), sellerController.login);
router.post('/send-otp', validate(sendOtpSchema), sellerController.sendOtp);
router.post(
  '/verify-otp',
  validate(verifyOtpSchema),
  sellerController.verifyOtp
);

// Protected routes
router.use(authenticate);
router.get('/dashboard', sellerController.getDashboard);
router.post('/logout', sellerController.logout);

// Profile routes
router.get('/profile', sellerProfileController.getProfile);
router.put('/profile', sellerProfileController.updateProfile);
router.post('/profile/change-password', sellerProfileController.changePassword);

export default router;
