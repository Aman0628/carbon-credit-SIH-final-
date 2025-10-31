import { db } from '../config';

export const cartService = {
  async getCart(buyer_id: string) {
    const cartItems = await db.cartItem.findMany({
      where: { buyer_id },
      include: {
        project: {
          select: {
            id: true,
            project_name: true,
            project_no: true,
            authority: true,
            seller: {
              select: {
                organization_name: true,
              },
            },
          },
        },
      },
      orderBy: { created_at: 'desc' },
    });

    const total = cartItems.reduce((sum, item) => sum + item.quantity, 0);

    return {
      items: cartItems,
      total_items: cartItems.length,
      total_credits: total,
    };
  },

  async addToCart(buyer_id: string, project_id: string, quantity: number) {
    const existingItem = await db.cartItem.findUnique({
      where: {
        buyer_id_project_id: {
          buyer_id,
          project_id,
        },
      },
    });

    if (existingItem) {
      return await db.cartItem.update({
        where: { id: existingItem.id },
        data: { quantity: existingItem.quantity + quantity },
        include: { project: true },
      });
    }

    return await db.cartItem.create({
      data: {
        buyer_id,
        project_id,
        quantity,
      },
      include: { project: true },
    });
  },

  async updateQuantity(
    cart_item_id: string,
    buyer_id: string,
    quantity: number
  ) {
    const item = await db.cartItem.findFirst({
      where: { id: cart_item_id, buyer_id },
    });

    if (!item) {
      throw new Error('Cart item not found');
    }

    if (quantity <= 0) {
      await db.cartItem.delete({ where: { id: cart_item_id } });
      return { message: 'Item removed from cart' };
    }

    return await db.cartItem.update({
      where: { id: cart_item_id },
      data: { quantity },
      include: { project: true },
    });
  },

  async removeFromCart(cart_item_id: string, buyer_id: string) {
    const item = await db.cartItem.findFirst({
      where: { id: cart_item_id, buyer_id },
    });

    if (!item) {
      throw new Error('Cart item not found');
    }

    await db.cartItem.delete({ where: { id: cart_item_id } });
    return { message: 'Item removed from cart' };
  },

  async clearCart(buyer_id: string) {
    await db.cartItem.deleteMany({ where: { buyer_id } });
    return { message: 'Cart cleared' };
  },
};
