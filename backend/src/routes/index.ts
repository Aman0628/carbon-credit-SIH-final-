import { Router } from 'express';
import adminRoutes from './admin.routes';
import buyerRoutes from './buyer.routes';
import sellerRoutes from './seller.routes';
import projectRoutes from './project.routes';

const router = Router();

router.use('/admin', adminRoutes);
router.use('/buyer', buyerRoutes);
router.use('/seller', sellerRoutes);
router.use('/projects', projectRoutes);

// Health check endpoint
router.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    message: 'Carbon Credit Marketplace API is running',
    timestamp: new Date().toISOString(),
  });
});

export default router;
