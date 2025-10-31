import { Request, Response, NextFunction } from 'express';
import { orderService } from '../services/order.service';

export const orderController = {
  async createOrder(req: Request, res: Response, next: NextFunction) {
    try {
      const buyer_id = req.user?.id;
      const { payment_method } = req.body;

      if (!buyer_id) {
        return res
          .status(401)
          .json({ success: false, message: 'Unauthorized' });
      }

      const order = await orderService.createOrder(buyer_id, payment_method);
      return res.status(201).json({
        success: true,
        message: 'Order created successfully',
        data: order,
      });
    } catch (error) {
      next(error);
    }
  },

  async getOrders(req: Request, res: Response, next: NextFunction) {
    try {
      const buyer_id = req.user?.id;

      if (!buyer_id) {
        return res
          .status(401)
          .json({ success: false, message: 'Unauthorized' });
      }

      const orders = await orderService.getOrders(buyer_id);
      return res.status(200).json({ success: true, data: orders });
    } catch (error) {
      next(error);
    }
  },

  async getOrderById(req: Request, res: Response, next: NextFunction) {
    try {
      const buyer_id = req.user?.id;
      const { order_id } = req.params;

      if (!buyer_id) {
        return res
          .status(401)
          .json({ success: false, message: 'Unauthorized' });
      }

      const order = await orderService.getOrderById(order_id, buyer_id);
      return res.status(200).json({ success: true, data: order });
    } catch (error) {
      next(error);
    }
  },
};
