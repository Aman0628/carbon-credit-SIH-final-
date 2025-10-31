import { Router } from 'express';
import { buyerController } from '../controllers';
import { buyerProfileController } from '../controllers/buyerProfile.controller';
import { cartController } from '../controllers/cart.controller';
import { orderController } from '../controllers/order.controller';
import { validate, authenticate } from '../middleware';
import {
  buyerSignupSchema,
  buyerLoginSchema,
  sendOtpSchema,
  verifyOtpSchema,
} from '../schemas';

const router = Router();

// Public routes
router.post('/signup', validate(buyerSignupSchema), buyerController.signup);
router.post('/login', validate(buyerLoginSchema), buyerController.login);
router.post('/send-otp', validate(sendOtpSchema), buyerController.sendOtp);
router.post(
  '/verify-otp',
  validate(verifyOtpSchema),
  buyerController.verifyOtp
);

// Protected routes
router.use(authenticate);
router.get('/dashboard', buyerController.getDashboard);
router.post('/logout', buyerController.logout);

// Profile routes
router.get('/profile', buyerProfileController.getProfile);
router.put('/profile', buyerProfileController.updateProfile);
router.post('/profile/change-password', buyerProfileController.changePassword);

// Cart routes
router.get('/cart', cartController.getCart);
router.post('/cart', cartController.addToCart);
router.put('/cart/:cart_item_id', cartController.updateQuantity);
router.delete('/cart/:cart_item_id', cartController.removeFromCart);
router.delete('/cart', cartController.clearCart);

// Order routes
router.post('/orders', orderController.createOrder);
router.get('/orders', orderController.getOrders);
router.get('/orders/:order_id', orderController.getOrderById);

export default router;
