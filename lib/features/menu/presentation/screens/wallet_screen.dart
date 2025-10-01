import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 'TXN001',
      'type': 'Credit',
      'description': 'Wallet Top-up',
      'amount': 5000,
      'date': '2024-01-20',
      'status': 'Completed',
      'method': 'UPI',
    },
    {
      'id': 'TXN002',
      'type': 'Debit',
      'description': 'Carbon Credit Purchase',
      'amount': 18000,
      'date': '2024-01-19',
      'status': 'Completed',
      'method': 'Wallet',
    },
    {
      'id': 'TXN003',
      'type': 'Credit',
      'description': 'Refund - Order Cancellation',
      'amount': 2500,
      'date': '2024-01-18',
      'status': 'Completed',
      'method': 'Wallet',
    },
    {
      'id': 'TXN004',
      'type': 'Debit',
      'description': 'Certificate Processing Fee',
      'amount': 500,
      'date': '2024-01-17',
      'status': 'Completed',
      'method': 'Wallet',
    },
    {
      'id': 'TXN005',
      'type': 'Credit',
      'description': 'Cashback Reward',
      'amount': 150,
      'date': '2024-01-16',
      'status': 'Completed',
      'method': 'Wallet',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showTransactionHistory(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Wallet Balance Card
          Container(
            margin: const EdgeInsets.all(16),
            child: Card(
              elevation: 8,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EXC Wallet Balance',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₹2,450.00',
                              style: AppTextStyles.heading1.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 48,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showAddMoneyDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Money'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showWithdrawDialog(),
                            icon: const Icon(Icons.remove),
                            label: const Text('Withdraw'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Quick Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'This Month',
                    '₹12,500',
                    'Spent',
                    Icons.trending_down,
                    AppColors.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Cashback',
                    '₹350',
                    'Earned',
                    Icons.trending_up,
                    AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tab Bar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Recent Transactions'),
              Tab(text: 'Rewards'),
            ],
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionsTab(),
                _buildRewardsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String period, String amount, String label, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  amount,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(period, style: AppTextStyles.caption),
                Text(label, style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildRewardsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rewards Summary
          Card(
            color: AppColors.success.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.stars,
                    color: AppColors.success,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total Rewards Earned',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '₹1,250',
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Reward Categories
          Text(
            'Reward Categories',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          _buildRewardCard(
            'Purchase Cashback',
            '₹850',
            '2.5% on all purchases',
            Icons.shopping_bag,
            AppColors.primary,
          ),
          _buildRewardCard(
            'Referral Bonus',
            '₹300',
            'Invite friends and earn',
            Icons.people,
            AppColors.info,
          ),
          _buildRewardCard(
            'Loyalty Points',
            '₹100',
            'Regular user benefits',
            Icons.loyalty,
            AppColors.warning,
          ),
          const SizedBox(height: 24),

          // Available Offers
          Text(
            'Available Offers',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          _buildOfferCard(
            'First Purchase Bonus',
            'Get 5% extra cashback on your first carbon credit purchase',
            '5% Cashback',
            true,
          ),
          _buildOfferCard(
            'Bulk Purchase Reward',
            'Purchase credits worth ₹50,000 or more and get ₹2,500 bonus',
            '₹2,500 Bonus',
            false,
          ),
          _buildOfferCard(
            'Monthly Challenge',
            'Complete 3 purchases this month and unlock exclusive rewards',
            'Exclusive Rewards',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    bool isCredit = transaction['type'] == 'Credit';
    Color amountColor = isCredit ? AppColors.success : AppColors.error;
    IconData icon = isCredit ? Icons.add_circle : Icons.remove_circle;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: amountColor.withOpacity(0.1),
          child: Icon(icon, color: amountColor),
        ),
        title: Text(
          transaction['description'],
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${transaction['date']} • ${transaction['method']}'),
            Text(
              'ID: ${transaction['id']}',
              style: AppTextStyles.caption.copyWith(
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isCredit ? '+' : '-'}₹${transaction['amount']}',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: amountColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                transaction['status'],
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.success,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showTransactionDetails(transaction),
      ),
    );
  }

  Widget _buildRewardCard(String title, String amount, String description, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: Text(
          amount,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildOfferCard(String title, String description, String reward, bool isActive) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Available',
                    style: AppTextStyles.caption.copyWith(
                      color: isActive ? AppColors.success : AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reward,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                if (!isActive)
                  TextButton(
                    onPressed: () => _activateOffer(title),
                    child: const Text('Activate'),
                  ),
              ],
            ),
          ],
        ),
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

  void _showWithdrawDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Money'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Available Balance: ₹2,450.00',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Bank Account',
                hintText: 'Select bank account',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              readOnly: true,
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
                const SnackBar(content: Text('Withdrawal request submitted!')),
              );
            },
            child: const Text('Withdraw'),
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

  void _showTransactionHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening full transaction history...')),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transaction Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Transaction ID', transaction['id']),
            _buildDetailRow('Type', transaction['type']),
            _buildDetailRow('Description', transaction['description']),
            _buildDetailRow('Amount', '₹${transaction['amount']}'),
            _buildDetailRow('Date', transaction['date']),
            _buildDetailRow('Status', transaction['status']),
            _buildDetailRow('Method', transaction['method']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Receipt downloaded!')),
              );
            },
            child: const Text('Download Receipt'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _activateOffer(String offerTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$offerTitle activated successfully!')),
    );
  }
}
