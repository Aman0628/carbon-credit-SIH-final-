import { Request, Response, NextFunction } from 'express';
import { cartService } from '../services/cart.service';

export const cartController = {
  async getCart(req: Request, res: Response, next: NextFunction) {
    try {
      const buyer_id = req.user?.id;

      if (!buyer_id) {
        return res
          .status(401)
          .json({ success: false, message: 'Unauthorized' });
      }

      const cart = await cartService.getCart(buyer_id);
      return res.status(200).json({ success: true, data: cart });
    } catch (error) {
      next(error);
    }
  },

  async addToCart(req: Request, res: Response, next: NextFunction) {
    try {
      const buyer_id = req.user?.id;
      const { project_id, quantity } = req.body;

      if (!buyer_id) {
        return res
          .status(401)
          .json({ success: false, message: 'Unauthorized' });
      }

      if (!project_id || !quantity || quantity <= 0) {
        return res
          .status(400)
          .json({ success: false, message: 'Invalid request data' });
      }

      const cartItem = await cartService.addToCart(
        buyer_id,
        project_id,
        quantity
      );
      return res.status(200).json({
        success: true,
        message: 'Item added to cart',
        data: cartItem,
      });
    } catch (error) {
      next(error);
    }
  },

  async updateQuantity(req: Request, res: Response, next: NextFunction) {
    try {
      const buyer_id = req.user?.id;
      const { cart_item_id } = req.params;
      const { quantity } = req.body;

      if (!buyer_id) {
        return res
          .status(401)
          .json({ success: false, message: 'Unauthorized' });
      }

      const result = await cartService.updateQuantity(
        cart_item_id,
        buyer_id,
        quantity
      );
      return res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  },

  async removeFromCart(req: Request, res: Response, next: NextFunction) {
    try {
      const buyer_id = req.user?.id;
      const { cart_item_id } = req.params;

      if (!buyer_id) {
        return res
          .status(401)
          .json({ success: false, message: 'Unauthorized' });
      }

      const result = await cartService.removeFromCart(cart_item_id, buyer_id);
      return res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  },

  async clearCart(req: Request, res: Response, next: NextFunction) {
    try {
      const buyer_id = req.user?.id;

      if (!buyer_id) {
        return res
          .status(401)
          .json({ success: false, message: 'Unauthorized' });
      }

      const result = await cartService.clearCart(buyer_id);
      return res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  },
};
