import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class PaymentOptionsScreen extends ConsumerStatefulWidget {
  const PaymentOptionsScreen({super.key});

  @override
  ConsumerState<PaymentOptionsScreen> createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends ConsumerState<PaymentOptionsScreen> {
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'type': 'Credit Card',
      'icon': Icons.credit_card,
      'details': '**** **** **** 4532',
      'expiry': '12/26',
      'isDefault': true,
      'color': AppColors.primary,
    },
    {
      'type': 'Debit Card',
      'icon': Icons.credit_card,
      'details': '**** **** **** 8901',
      'expiry': '08/25',
      'isDefault': false,
      'color': AppColors.success,
    },
    {
      'type': 'UPI',
      'icon': Icons.payment,
      'details': 'user@paytm',
      'expiry': '',
      'isDefault': false,
      'color': AppColors.info,
    },
    {
      'type': 'Net Banking',
      'icon': Icons.account_balance,
      'details': 'HDFC Bank',
      'expiry': '',
      'isDefault': false,
      'color': AppColors.warning,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Options'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddPaymentMethodDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Balance Card
            Card(
              color: AppColors.primary.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 40,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EXC Wallet Balance',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '₹2,450.00',
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _showAddMoneyDialog(),
                      child: const Text('Add Money'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Methods Section
            Text(
              'Saved Payment Methods',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 16),

            // Payment Methods List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final method = _paymentMethods[index];
                return _buildPaymentMethodCard(method, index);
              },
            ),
            const SizedBox(height: 24),

            // Transaction History
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: AppTextStyles.heading3,
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to full transaction history
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Full transaction history coming soon!')),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Recent Transactions List
            _buildTransactionItem('Credit Purchase', '₹18,000', '2 hours ago', Icons.shopping_cart, AppColors.error),
            _buildTransactionItem('Wallet Top-up', '₹5,000', '1 day ago', Icons.add_circle, AppColors.success),
            _buildTransactionItem('Certificate Fee', '₹500', '3 days ago', Icons.verified, AppColors.warning),
            _buildTransactionItem('Credit Sale', '₹12,000', '5 days ago', Icons.sell, AppColors.success),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: method['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                method['icon'],
                color: method['color'],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        method['type'],
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (method['isDefault']) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Default',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    method['details'],
                    style: AppTextStyles.bodyMedium,
                  ),
                  if (method['expiry'].isNotEmpty)
                    Text(
                      'Expires: ${method['expiry']}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) => _handlePaymentMethodAction(value, index),
              itemBuilder: (context) => [
                if (!method['isDefault'])
                  const PopupMenuItem(
                    value: 'default',
                    child: Text('Set as Default'),
                  ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(String title, String amount, String time, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title),
        subtitle: Text(time),
        trailing: Text(
          amount,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }

  void _handlePaymentMethodAction(String action, int index) {
    switch (action) {
      case 'default':
        setState(() {
          for (var method in _paymentMethods) {
            method['isDefault'] = false;
          }
          _paymentMethods[index]['isDefault'] = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Default payment method updated')),
        );
        break;
      case 'edit':
        _showEditPaymentMethodDialog(_paymentMethods[index]);
        break;
      case 'delete':
        _showDeleteConfirmationDialog(index);
        break;
    }
  }

  void _showAddPaymentMethodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Credit/Debit Card'),
              onTap: () {
                Navigator.pop(context);
                _showCardDetailsDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('UPI'),
              onTap: () {
                Navigator.pop(context);
                _showUPIDetailsDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Net Banking'),
              onTap: () {
                Navigator.pop(context);
                _showNetBankingDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCardDetailsDialog() {
    // TODO: Implement card details form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card details form coming soon!')),
    );
  }

  void _showUPIDetailsDialog() {
    // TODO: Implement UPI details form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('UPI details form coming soon!')),
    );
  }

  void _showNetBankingDialog() {
    // TODO: Implement net banking selection
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Net banking selection coming soon!')),
    );
  }

  void _showEditPaymentMethodDialog(Map<String, dynamic> method) {
    // TODO: Implement edit payment method
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit payment method coming soon!')),
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment Method'),
        content: const Text('Are you sure you want to delete this payment method?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _paymentMethods.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment method deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddMoneyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Money to Wallet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text('Quick amounts:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildQuickAmountChip('₹500'),
                _buildQuickAmountChip('₹1000'),
                _buildQuickAmountChip('₹2000'),
                _buildQuickAmountChip('₹5000'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Money added to wallet successfully!')),
              );
            },
            child: const Text('Add Money'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAmountChip(String amount) {
    return ActionChip(
      label: Text(amount),
      onPressed: () {
        // TODO: Set amount in text field
      },
    );
  }
}
