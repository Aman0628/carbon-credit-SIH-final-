import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'monthly';
  String _selectedReportType = 'trading';

  final Map<String, String> _periods = {
    'weekly': 'Last 7 Days',
    'monthly': 'Last 30 Days',
    'quarterly': 'Last 3 Months',
    'yearly': 'Last Year',
  };

  final Map<String, String> _reportTypes = {
    'trading': 'Trading Activity',
    'emissions': 'Emissions Report',
    'compliance': 'Compliance Status',
    'financial': 'Financial Summary',
  };

  final List<Map<String, dynamic>> _tradingData = [
    {
      'date': '2024-01-20',
      'type': 'Purchase',
      'credits': 50,
      'amount': 42500,
      'project': 'Solar Farm Maharashtra',
      'price': 850,
    },
    {
      'date': '2024-01-19',
      'type': 'Sale',
      'credits': 25,
      'amount': 23000,
      'project': 'Wind Energy Gujarat',
      'price': 920,
    },
    {
      'date': '2024-01-18',
      'type': 'Purchase',
      'credits': 30,
      'amount': 19500,
      'project': 'Reforestation Himachal',
      'price': 650,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Reports & Analytics'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareReport,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Trading', icon: Icon(Icons.trending_up)),
            Tab(text: 'Emissions', icon: Icon(Icons.eco)),
            Tab(text: 'Compliance', icon: Icon(Icons.verified)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter Bar
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPeriod,
                    decoration: const InputDecoration(
                      labelText: 'Period',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _periods.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPeriod = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedReportType,
                    decoration: const InputDecoration(
                      labelText: 'Report Type',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _reportTypes.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedReportType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildTradingTab(),
                _buildEmissionsTab(),
                _buildComplianceTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Overview',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),

          // Key Metrics
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildMetricCard(
                'Total Credits',
                '125',
                '+15%',
                Icons.eco,
                AppColors.primary,
                true,
              ),
              _buildMetricCard(
                'Total Value',
                '₹98,750',
                '+8.2%',
                Icons.account_balance_wallet,
                AppColors.success,
                true,
              ),
              _buildMetricCard(
                'Avg. Price',
                '₹790',
                '-2.1%',
                Icons.trending_down,
                AppColors.error,
                false,
              ),
              _buildMetricCard(
                'Transactions',
                '23',
                '+12%',
                Icons.swap_horiz,
                AppColors.info,
                true,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Chart Placeholder
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trading Activity Trend',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.show_chart,
                            size: 48,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Interactive Chart',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            'Coming Soon',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Recent Activity
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activity',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(3, (index) {
                    final activity = _tradingData[index];
                    return _buildActivityItem(activity);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trading Report',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),

          // Trading Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trading Summary',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryItem(
                          'Total Purchases',
                          '80 credits',
                          '₹62,000',
                          AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryItem(
                          'Total Sales',
                          '45 credits',
                          '₹36,750',
                          AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryItem(
                          'Net Position',
                          '35 credits',
                          '₹25,250',
                          AppColors.info,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryItem(
                          'Avg. Price',
                          '₹790/credit',
                          'Market Rate',
                          AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Detailed Transactions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction Details',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(_tradingData.length, (index) {
                    final transaction = _tradingData[index];
                    return _buildTransactionItem(transaction);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmissionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emissions Report',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),

          // Emissions Overview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Carbon Footprint Analysis',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 16),
                  _buildEmissionItem(
                    'Total Emissions',
                    '2,450 tCO₂e',
                    'Calculated emissions for the period',
                    Icons.cloud,
                    AppColors.error,
                  ),
                  _buildEmissionItem(
                    'Credits Purchased',
                    '80 credits',
                    'Carbon credits acquired for offsetting',
                    Icons.eco,
                    AppColors.success,
                  ),
                  _buildEmissionItem(
                    'Net Emissions',
                    '2,370 tCO₂e',
                    'Remaining emissions after offsetting',
                    Icons.trending_down,
                    AppColors.warning,
                  ),
                  _buildEmissionItem(
                    'Offset Percentage',
                    '3.3%',
                    'Percentage of emissions offset',
                    Icons.percent,
                    AppColors.info,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Emission Sources
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emission Sources Breakdown',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 16),
                  _buildSourceItem('Energy Consumption', '45%', AppColors.primary),
                  _buildSourceItem('Transportation', '30%', AppColors.success),
                  _buildSourceItem('Manufacturing', '20%', AppColors.warning),
                  _buildSourceItem('Other Sources', '5%', AppColors.info),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compliance Status',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),

          // Compliance Overview
          Card(
            color: AppColors.success.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 48,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Compliance Status: GOOD',
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your carbon trading activities are compliant with current regulations.',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Compliance Checklist
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Compliance Checklist',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 16),
                  _buildComplianceItem(
                    'KYC Verification',
                    'Identity verification completed',
                    true,
                  ),
                  _buildComplianceItem(
                    'MRV Certificate',
                    'Monitoring, Reporting & Verification',
                    true,
                  ),
                  _buildComplianceItem(
                    'Transaction Records',
                    'All transactions properly documented',
                    true,
                  ),
                  _buildComplianceItem(
                    'Regulatory Reporting',
                    'Quarterly reports submitted',
                    false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Regulatory Updates
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Regulatory Updates',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 16),
                  _buildUpdateItem(
                    'New Carbon Tax Regulations',
                    'Updated tax structure for carbon credits',
                    '2 days ago',
                  ),
                  _buildUpdateItem(
                    'Enhanced Verification Standards',
                    'Stricter MRV requirements implemented',
                    '1 week ago',
                  ),
                  _buildUpdateItem(
                    'International Trading Guidelines',
                    'New cross-border trading protocols',
                    '2 weeks ago',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String change, IconData icon, Color color, bool isPositive) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isPositive ? AppColors.success : AppColors.error).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    change,
                    style: AppTextStyles.caption.copyWith(
                      color: isPositive ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: AppTextStyles.heading3.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    final isPositive = activity['type'] == 'Sale';
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isPositive 
                ? AppColors.success.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.1),
            child: Icon(
              isPositive ? Icons.trending_up : Icons.trending_down,
              color: isPositive ? AppColors.success : AppColors.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${activity['type']} - ${activity['credits']} credits',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  activity['project'],
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Text(
            '₹${activity['amount']}',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isPositive ? AppColors.success : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final isPositive = transaction['type'] == 'Sale';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transaction['date']} - ${transaction['type']}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${transaction['credits']} credits @ ₹${transaction['price']}/credit',
                  style: AppTextStyles.caption,
                ),
                Text(
                  transaction['project'],
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Text(
            '₹${transaction['amount']}',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: isPositive ? AppColors.success : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmissionItem(String title, String value, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceItem(String source, String percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(source, style: AppTextStyles.bodyMedium),
          ),
          Container(
            width: 100,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: double.parse(percentage.replaceAll('%', '')) / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              percentage,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceItem(String title, String description, bool isCompliant) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            isCompliant ? Icons.check_circle : Icons.warning,
            color: isCompliant ? AppColors.success : AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: (isCompliant ? AppColors.success : AppColors.warning).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isCompliant ? 'Complete' : 'Pending',
              style: AppTextStyles.caption.copyWith(
                color: isCompliant ? AppColors.success : AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(String title, String description, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.caption,
                ),
                Text(
                  time,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report exported successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _shareReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report sharing options coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
