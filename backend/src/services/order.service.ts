import { db } from '../config';

export const orderService = {
  async createOrder(buyer_id: string, payment_method?: string) {
    const cartItems = await db.cartItem.findMany({
      where: { buyer_id },
      include: { project: true },
    });

    if (cartItems.length === 0) {
      throw new Error('Cart is empty');
    }

    // Note: In a real application, you'd fetch actual prices from projects
    // For now, using placeholder price_per_credit
    const PRICE_PER_CREDIT = 100; // Placeholder

    const total_credits = cartItems.reduce(
      (sum, item) => sum + item.quantity,
      0
    );
    const total_amount = total_credits * PRICE_PER_CREDIT;

    const order = await db.order.create({
      data: {
        buyer_id,
        total_amount,
        total_credits,
        payment_method,
        orderItems: {
          create: cartItems.map((item) => ({
            project_id: item.project_id,
            quantity: item.quantity,
            price_per_credit: PRICE_PER_CREDIT,
            subtotal: item.quantity * PRICE_PER_CREDIT,
          })),
        },
      },
      include: {
        orderItems: {
          include: { project: true },
        },
      },
    });

    // Clear cart after order creation
    await db.cartItem.deleteMany({ where: { buyer_id } });

    return order;
  },

  async getOrders(buyer_id: string) {
    return await db.order.findMany({
      where: { buyer_id },
      include: {
        orderItems: {
          include: {
            project: {
              select: {
                project_name: true,
                project_no: true,
                seller: {
                  select: { organization_name: true },
                },
              },
            },
          },
        },
      },
      orderBy: { created_at: 'desc' },
    });
  },

  async getOrderById(order_id: string, buyer_id: string) {
    const order = await db.order.findFirst({
      where: { id: order_id, buyer_id },
      include: {
        orderItems: {
          include: {
            project: {
              include: {
                seller: {
                  select: { organization_name: true, organization_email: true },
                },
              },
            },
          },
        },
      },
    });

    if (!order) {
      throw new Error('Order not found');
    }

    return order;
  },

  async updateOrderStatus(order_id: string, status: string) {
    return await db.order.update({
      where: { id: order_id },
      data: { status: status as any },
    });
  },
};
