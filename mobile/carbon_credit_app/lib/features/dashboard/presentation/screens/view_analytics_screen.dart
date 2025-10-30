import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class ViewAnalyticsScreen extends ConsumerStatefulWidget {
  const ViewAnalyticsScreen({super.key});

  @override
  ConsumerState<ViewAnalyticsScreen> createState() => _ViewAnalyticsScreenState();
}

class _ViewAnalyticsScreenState extends ConsumerState<ViewAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedPeriod = 'Last 30 Days';

  final List<String> periods = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 3 Months',
    'Last 6 Months',
    'Last Year',
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
        title: const Text('Sales Analytics'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.date_range),
            onSelected: (value) {
              setState(() {
                selectedPeriod = value;
              });
            },
            itemBuilder: (context) => periods.map((period) {
              return PopupMenuItem(
                value: period,
                child: Text(period),
              );
            }).toList(),
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => _exportReport(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Sales'),
            Tab(text: 'Performance'),
            Tab(text: 'Buyers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildSalesTab(),
          _buildPerformanceTab(),
          _buildBuyersTab(),
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
          // Period Selector
          Text(
            'Analytics for $selectedPeriod',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),

          // Key Metrics
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Revenue',
                  '₹2.4L',
                  '+15.2%',
                  Icons.currency_rupee,
                  AppColors.success,
                  true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Credits Sold',
                  '650',
                  '+8.5%',
                  Icons.trending_up,
                  AppColors.primary,
                  true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Avg Price',
                  '₹820',
                  '+3.2%',
                  Icons.local_offer,
                  AppColors.info,
                  true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Conversion',
                  '23.5%',
                  '-2.1%',
                  Icons.percent,
                  AppColors.warning,
                  false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Revenue Trend Chart
          Text(
            'Revenue Trend',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
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
                            'Revenue Chart',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Interactive chart showing revenue over time',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Top Performing Projects
          Text(
            'Top Performing Projects',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _buildProjectPerformanceItem(
                  'Solar Farm Maharashtra',
                  '₹1.2L',
                  '300 credits',
                  '85%',
                  AppColors.success,
                ),
                const Divider(height: 1),
                _buildProjectPerformanceItem(
                  'Wind Energy Gujarat',
                  '₹95K',
                  '150 credits',
                  '78%',
                  AppColors.primary,
                ),
                const Divider(height: 1),
                _buildProjectPerformanceItem(
                  'Reforestation Himachal',
                  '₹65K',
                  '200 credits',
                  '65%',
                  AppColors.info,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sales Summary
          Text(
            'Sales Summary',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Sales',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '₹2,40,000',
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Credits Sold',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '650',
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Recent Transactions
          Text(
            'Recent Transactions',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _buildTransactionItem(
                  'EcoTech Industries',
                  'Solar Farm Maharashtra',
                  '50 credits',
                  '₹42,500',
                  '2 days ago',
                  AppColors.success,
                ),
                const Divider(height: 1),
                _buildTransactionItem(
                  'Green Solutions Ltd',
                  'Wind Energy Gujarat',
                  '25 credits',
                  '₹23,000',
                  '5 days ago',
                  AppColors.primary,
                ),
                const Divider(height: 1),
                _buildTransactionItem(
                  'Carbon Neutral Corp',
                  'Reforestation Himachal',
                  '75 credits',
                  '₹48,750',
                  '1 week ago',
                  AppColors.info,
                ),
                const Divider(height: 1),
                _buildTransactionItem(
                  'Sustainable Energy Co',
                  'Solar Farm Maharashtra',
                  '100 credits',
                  '₹85,000',
                  '2 weeks ago',
                  AppColors.success,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sales by Project Type
          Text(
            'Sales by Project Type',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProjectTypeBar('Renewable Energy', 0.75, '₹1.8L', AppColors.success),
                  const SizedBox(height: 16),
                  _buildProjectTypeBar('Forestry', 0.25, '₹0.6L', AppColors.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Performance Metrics
          Text(
            'Performance Metrics',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPerformanceCard(
                  'Listing Views',
                  '2,450',
                  '+12%',
                  Icons.visibility,
                  AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPerformanceCard(
                  'Inquiries',
                  '185',
                  '+8%',
                  Icons.message,
                  AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPerformanceCard(
                  'Avg Response Time',
                  '2.5 hrs',
                  '-15%',
                  Icons.schedule,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPerformanceCard(
                  'Customer Rating',
                  '4.8/5',
                  '+0.2',
                  Icons.star,
                  AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Market Position
          Text(
            'Market Position',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildMarketPositionItem(
                    'Price Competitiveness',
                    'Above Average',
                    '3.2% above market',
                    AppColors.success,
                    Icons.trending_up,
                  ),
                  const SizedBox(height: 16),
                  _buildMarketPositionItem(
                    'Market Share',
                    'Growing',
                    '2.1% of total market',
                    AppColors.primary,
                    Icons.pie_chart,
                  ),
                  const SizedBox(height: 16),
                  _buildMarketPositionItem(
                    'Demand Trend',
                    'High Demand',
                    'Peak season active',
                    AppColors.warning,
                    Icons.show_chart,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Recommendations
          Text(
            'Recommendations',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _buildRecommendationItem(
                  'Optimize Pricing',
                  'Consider reducing price by 2-3% to increase sales volume',
                  Icons.price_change,
                  AppColors.warning,
                ),
                const Divider(height: 1),
                _buildRecommendationItem(
                  'Expand Portfolio',
                  'Add more forestry projects to diversify offerings',
                  Icons.add_business,
                  AppColors.info,
                ),
                const Divider(height: 1),
                _buildRecommendationItem(
                  'Improve Response Time',
                  'Faster responses can increase conversion by 15%',
                  Icons.speed,
                  AppColors.success,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Buyer Demographics
          Text(
            'Buyer Demographics',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDemographicCard(
                  'Total Buyers',
                  '45',
                  Icons.people,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDemographicCard(
                  'Repeat Buyers',
                  '28%',
                  Icons.repeat,
                  AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Top Buyers
          Text(
            'Top Buyers',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _buildBuyerItem(
                  'EcoTech Industries',
                  '150 credits',
                  '₹1.2L',
                  'Manufacturing',
                  AppColors.success,
                ),
                const Divider(height: 1),
                _buildBuyerItem(
                  'Green Solutions Ltd',
                  '85 credits',
                  '₹68K',
                  'Technology',
                  AppColors.primary,
                ),
                const Divider(height: 1),
                _buildBuyerItem(
                  'Carbon Neutral Corp',
                  '75 credits',
                  '₹61K',
                  'Energy',
                  AppColors.info,
                ),
                const Divider(height: 1),
                _buildBuyerItem(
                  'Sustainable Energy Co',
                  '65 credits',
                  '₹52K',
                  'Utilities',
                  AppColors.warning,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Buyer Sectors
          Text(
            'Buyer Sectors',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSectorBar('Manufacturing', 0.4, '40%', AppColors.primary),
                  const SizedBox(height: 12),
                  _buildSectorBar('Technology', 0.25, '25%', AppColors.success),
                  const SizedBox(height: 12),
                  _buildSectorBar('Energy', 0.2, '20%', AppColors.info),
                  const SizedBox(height: 12),
                  _buildSectorBar('Others', 0.15, '15%', AppColors.warning),
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
              children: [
                Icon(icon, color: color, size: 20),
                const Spacer(),
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? AppColors.success : AppColors.error,
                  size: 16,
                ),
                Text(
                  change,
                  style: AppTextStyles.caption.copyWith(
                    color: isPositive ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.heading3.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectPerformanceItem(String name, String revenue, String credits, String performance, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(Icons.eco, color: color),
      ),
      title: Text(name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text('$credits sold'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            revenue,
            style: AppTextStyles.bodyLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            performance,
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String buyer, String project, String credits, String amount, String time, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(Icons.business, color: color),
      ),
      title: Text(buyer, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text('$project • $credits'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            amount,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            time,
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectTypeBar(String type, double percentage, String revenue, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(type, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            Text(revenue, style: AppTextStyles.bodyMedium.copyWith(color: color)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: AppColors.divider,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildPerformanceCard(String title, String value, String change, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.bodyLarge.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              change,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.success,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketPositionItem(String title, String status, String details, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              Text(details, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationItem(String title, String description, IconData icon, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(description, style: AppTextStyles.caption),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
    );
  }

  Widget _buildDemographicCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.heading3.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyerItem(String name, String credits, String amount, String sector, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(Icons.business, color: color),
      ),
      title: Text(name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text('$sector • $credits'),
      trailing: Text(
        amount,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.success,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectorBar(String sector, double percentage, String percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(sector, style: AppTextStyles.bodyMedium),
            Text(percent, style: AppTextStyles.bodyMedium.copyWith(color: color)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: AppColors.divider,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  void _exportReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Analytics Report'),
        content: const Text(
          'Choose the format for your analytics report:\n\n'
          '• PDF - Comprehensive report with charts\n'
          '• Excel - Raw data for further analysis\n'
          '• CSV - Transaction data export',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Analytics report exported successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Export PDF'),
          ),
        ],
      ),
    );
  }
}
