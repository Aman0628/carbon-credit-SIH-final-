import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class UPIPaymentsScreen extends ConsumerStatefulWidget {
  const UPIPaymentsScreen({super.key});

  @override
  ConsumerState<UPIPaymentsScreen> createState() => _UPIPaymentsScreenState();
}

class _UPIPaymentsScreenState extends ConsumerState<UPIPaymentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _upiIdController = TextEditingController();
  final _amountController = TextEditingController();

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'upi',
      'name': 'UPI Payment',
      'icon': Icons.account_balance_wallet,
      'description': 'Pay using UPI ID or QR code',
      'enabled': true,
    },
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'icon': Icons.credit_card,
      'description': 'Pay using your bank card',
      'enabled': true,
    },
    {
      'id': 'netbanking',
      'name': 'Net Banking',
      'icon': Icons.account_balance,
      'description': 'Pay through internet banking',
      'enabled': true,
    },
    {
      'id': 'wallet',
      'name': 'Digital Wallet',
      'icon': Icons.wallet,
      'description': 'Paytm, PhonePe, Google Pay',
      'enabled': true,
    },
  ];

  final List<Map<String, dynamic>> _recentTransactions = [
    {
      'id': 'TXN001',
      'type': 'Purchase',
      'amount': '₹42,500',
      'credits': '50 credits',
      'project': 'Solar Farm Maharashtra',
      'date': '2024-01-20',
      'status': 'Completed',
      'method': 'UPI',
    },
    {
      'id': 'TXN002',
      'type': 'Sale',
      'amount': '₹23,000',
      'credits': '25 credits',
      'project': 'Wind Energy Gujarat',
      'date': '2024-01-19',
      'status': 'Completed',
      'method': 'Card',
    },
    {
      'id': 'TXN003',
      'type': 'Purchase',
      'amount': '₹18,750',
      'credits': '30 credits',
      'project': 'Reforestation Himachal',
      'date': '2024-01-18',
      'status': 'Pending',
      'method': 'UPI',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _upiIdController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments & Transactions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pay Now', icon: Icon(Icons.payment)),
            Tab(text: 'History', icon: Icon(Icons.history)),
            Tab(text: 'Settings', icon: Icon(Icons.settings)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPaymentTab(),
          _buildHistoryTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  Widget _buildPaymentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Quick Actions
          Text(
            'Quick Actions',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Buy Credits',
                  'Purchase carbon credits',
                  Icons.shopping_cart,
                  AppColors.primary,
                  () => _showPaymentDialog('buy'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'Sell Credits',
                  'List your credits for sale',
                  Icons.sell,
                  AppColors.success,
                  () => _showPaymentDialog('sell'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Payment Methods
          Text(
            'Payment Methods',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          ...List.generate(_paymentMethods.length, (index) {
            final method = _paymentMethods[index];
            return _buildPaymentMethodCard(method);
          }),
          const SizedBox(height: 24),

          // UPI Quick Pay
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flash_on, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Text(
                        'Quick UPI Payment',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _upiIdController,
                    decoration: const InputDecoration(
                      labelText: 'UPI ID',
                      hintText: 'yourname@paytm',
                      prefixIcon: Icon(Icons.alternate_email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount (₹)',
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.currency_rupee),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _processUPIPayment,
                      icon: const Icon(Icons.payment),
                      label: const Text('Pay Now'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Column(
      children: [
        // Filter Bar
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search transactions...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => _showFilterDialog(),
                icon: const Icon(Icons.filter_list),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
        
        // Transaction List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _recentTransactions.length,
            itemBuilder: (context, index) {
              final transaction = _recentTransactions[index];
              return _buildTransactionCard(transaction);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Settings',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 24),

          // Saved Payment Methods
          _buildSettingsSection(
            'Saved Payment Methods',
            [
              _buildSettingsItem(
                'Manage UPI IDs',
                'Add or remove UPI payment methods',
                Icons.account_balance_wallet,
                () => _showManageUPIDialog(),
              ),
              _buildSettingsItem(
                'Saved Cards',
                'Manage your saved credit/debit cards',
                Icons.credit_card,
                () => _showManageCardsDialog(),
              ),
              _buildSettingsItem(
                'Bank Accounts',
                'Link your bank accounts for payments',
                Icons.account_balance,
                () => _showManageBankDialog(),
              ),
            ],
          ),

          // Security Settings
          _buildSettingsSection(
            'Security & Privacy',
            [
              _buildSettingsItem(
                'Transaction PIN',
                'Set up PIN for secure transactions',
                Icons.security,
                () => _showSetPINDialog(),
              ),
              _buildSettingsItem(
                'Biometric Authentication',
                'Use fingerprint or face unlock',
                Icons.fingerprint,
                () => _toggleBiometric(),
              ),
              _buildSettingsItem(
                'Transaction Limits',
                'Set daily and monthly limits',
                Icons.speed,
                () => _showLimitsDialog(),
              ),
            ],
          ),

          // Notifications
          _buildSettingsSection(
            'Notifications',
            [
              _buildSettingsItem(
                'Payment Alerts',
                'Get notified about transactions',
                Icons.notifications,
                () => _toggleNotifications(),
              ),
              _buildSettingsItem(
                'Email Receipts',
                'Receive transaction receipts via email',
                Icons.email,
                () => _toggleEmailReceipts(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(method['icon'], color: AppColors.primary),
        ),
        title: Text(method['name']),
        subtitle: Text(method['description']),
        trailing: method['enabled'] 
            ? Icon(Icons.check_circle, color: AppColors.success)
            : Icon(Icons.settings, color: AppColors.textSecondary),
        onTap: () => _selectPaymentMethod(method['id']),
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isPositive = transaction['type'] == 'Sale';
    final statusColor = transaction['status'] == 'Completed' 
        ? AppColors.success 
        : AppColors.warning;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPositive 
              ? AppColors.success.withOpacity(0.1)
              : AppColors.primary.withOpacity(0.1),
          child: Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: isPositive ? AppColors.success : AppColors.primary,
          ),
        ),
        title: Text('${transaction['type']} - ${transaction['credits']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction['project']),
            Text('${transaction['date']} • ${transaction['method']}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              transaction['amount'],
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: isPositive ? AppColors.success : AppColors.primary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                transaction['status'],
                style: AppTextStyles.caption.copyWith(
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showTransactionDetails(transaction),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.heading3,
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: items,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSettingsItem(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _processUPIPayment() {
    if (_upiIdController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pay ₹${_amountController.text} to ${_upiIdController.text}?'),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Processing payment...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successful!'),
          backgroundColor: AppColors.success,
        ),
      );
      _upiIdController.clear();
      _amountController.clear();
    });
  }

  void _showPaymentDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(type == 'buy' ? 'Buy Carbon Credits' : 'Sell Carbon Credits'),
        content: Text(
          type == 'buy' 
              ? 'This will redirect you to the marketplace to purchase carbon credits.'
              : 'This will help you list your carbon credits for sale.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _selectPaymentMethod(String methodId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected payment method: $methodId'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction ${transaction['id']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Type', transaction['type']),
            _buildDetailRow('Amount', transaction['amount']),
            _buildDetailRow('Credits', transaction['credits']),
            _buildDetailRow('Project', transaction['project']),
            _buildDetailRow('Date', transaction['date']),
            _buildDetailRow('Method', transaction['method']),
            _buildDetailRow('Status', transaction['status']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
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
            width: 80,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filter options coming soon!')),
    );
  }

  void _showManageUPIDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('UPI management coming soon!')),
    );
  }

  void _showManageCardsDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card management coming soon!')),
    );
  }

  void _showManageBankDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bank account management coming soon!')),
    );
  }

  void _showSetPINDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PIN setup coming soon!')),
    );
  }

  void _toggleBiometric() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Biometric settings updated!')),
    );
  }

  void _showLimitsDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction limits coming soon!')),
    );
  }

  void _toggleNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification settings updated!')),
    );
  }

  void _toggleEmailReceipts() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email receipt settings updated!')),
    );
  }
}
