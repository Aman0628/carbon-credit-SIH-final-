import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/cart_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _selectedPaymentMethod = 'wallet';
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _upiIdController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    if (cartState.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(
          child: Text('No items in cart'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/cart'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Summary
                  Text(
                    'Order Summary',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ...cartState.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.listing.projectName} × ${item.quantity}',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ),
                                Text(
                                  '₹${item.totalPrice.toStringAsFixed(0)}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )),
                          const Divider(),
                          Row(
                            children: [
                              const Expanded(child: Text('Subtotal')),
                              Text('₹${cartState.subtotal.toStringAsFixed(0)}'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Expanded(child: Text('GST (18%)')),
                              Text('₹${cartState.tax.toStringAsFixed(0)}'),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Total',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                '₹${cartState.total.toStringAsFixed(0)}',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Payment Method
                  Text(
                    'Payment Method',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 12),
                  
                  // Payment Options
                  _buildPaymentOption(
                    'wallet',
                    'Wallet',
                    'Pay using your wallet balance',
                    Icons.account_balance_wallet,
                  ),
                  _buildPaymentOption(
                    'upi',
                    'UPI',
                    'Pay using UPI ID',
                    Icons.payment,
                  ),
                  _buildPaymentOption(
                    'card',
                    'Credit/Debit Card',
                    'Pay using card',
                    Icons.credit_card,
                  ),
                  _buildPaymentOption(
                    'netbanking',
                    'Net Banking',
                    'Pay using internet banking',
                    Icons.account_balance,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Payment Form
                  _buildPaymentForm(),
                ],
              ),
            ),
          ),
          
          // Pay Button
          Container(
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
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cartState.isLoading ? null : _processPayment,
                  child: cartState.isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('Processing...'),
                          ],
                        )
                      : Text('Pay ₹${cartState.total.toStringAsFixed(0)}'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: RadioListTile<String>(
        value: value,
        groupValue: _selectedPaymentMethod,
        onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
        title: Text(title, style: AppTextStyles.bodyLarge),
        subtitle: Text(subtitle, style: AppTextStyles.bodyMedium),
        secondary: Icon(icon, color: AppColors.primary),
      ),
    );
  }

  Widget _buildPaymentForm() {
    switch (_selectedPaymentMethod) {
      case 'upi':
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: _upiIdController,
              decoration: const InputDecoration(
                labelText: 'UPI ID',
                hintText: 'example@upi',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        );
      case 'card':
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    hintText: '1234 5678 9012 3456',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryController,
                        decoration: const InputDecoration(
                          labelText: 'Expiry',
                          hintText: 'MM/YY',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          hintText: '123',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      case 'wallet':
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet, color: AppColors.success),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wallet Balance',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₹15,000 available',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _processPayment() async {
    final result = await ref.read(cartProvider.notifier).processCheckout(_selectedPaymentMethod);
    
    if (result['success'] == true && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 48,
          ),
          title: const Text('Payment Successful!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Transaction ID: ${result['transaction_id']}',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Amount: ₹${result['amount'].toStringAsFixed(0)}',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/certificates');
              },
              child: const Text('View Certificates'),
            ),
          ],
        ),
      );
    }
  }
}
