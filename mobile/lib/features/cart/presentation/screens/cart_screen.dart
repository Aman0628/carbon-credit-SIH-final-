import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/models/credit_listing.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/marketplace'),
        ),
      ),
      body: cartState.items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: AppColors.textHint,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: AppTextStyles.heading3,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add some carbon credits to get started',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartState.items.length,
                    itemBuilder: (context, index) {
                      final item = cartState.items[index];
                      return _buildCartItem(context, ref, item);
                    },
                  ),
                ),
                _buildCartSummary(context, ref, cartState),
              ],
            ),
    );
  }

  Widget _buildCartItem(BuildContext context, WidgetRef ref, CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.listing.projectName,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.listing.location,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => ref.read(cartProvider.notifier).removeFromCart(item.listingId),
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'EXC${item.listing.pricePerCredit.toStringAsFixed(0)} per credit',
                  style: AppTextStyles.bodyMedium,
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: item.quantity > 1
                            ? () => ref.read(cartProvider.notifier).updateQuantity(
                                  item.listingId,
                                  item.quantity - 1,
                                )
                            : null,
                        icon: const Icon(Icons.remove),
                        iconSize: 16,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          item.quantity.toString(),
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: item.quantity < item.listing.availableCredits
                            ? () => ref.read(cartProvider.notifier).updateQuantity(
                                  item.listingId,
                                  item.quantity + 1,
                                )
                            : null,
                        icon: const Icon(Icons.add),
                        iconSize: 16,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: EXC${item.totalPrice.toStringAsFixed(0)}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified,
                        size: 12,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.listing.certificationBody,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, WidgetRef ref, CartState cartState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal (${cartState.itemCount} credits)',
                  style: AppTextStyles.bodyLarge,
                ),
                Text(
                  'EXC${cartState.subtotal.toStringAsFixed(0)}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GST (18%)',
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  'EXC${cartState.tax.toStringAsFixed(0)}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTextStyles.heading3,
                ),
                Text(
                  'EXC${cartState.total.toStringAsFixed(0)}',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cartState.items.isNotEmpty
                    ? () => context.go('/checkout')
                    : null,
                child: const Text('Proceed to Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
