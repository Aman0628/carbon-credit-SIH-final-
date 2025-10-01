import { Router } from 'express';
import { adminRouter} from './admin';
import { buyerRouter} from './buyer';
import { sellerRouter } from './seller';
export const mainRouter = Router();


mainRouter.use('/admin', adminRouter)
mainRouter.use('/buyer', buyerRouter)
mainRouter.use('/seller', sellerRouter)