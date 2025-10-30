import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class SellerMarketplaceScreen extends ConsumerStatefulWidget {
  const SellerMarketplaceScreen({super.key});

  @override
  ConsumerState<SellerMarketplaceScreen> createState() => _SellerMarketplaceScreenState();
}

class _SellerMarketplaceScreenState extends ConsumerState<SellerMarketplaceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _myListings = [
    {
      'id': 'CC001',
      'title': 'Solar Farm Credits - Rajasthan',
      'credits': 500,
      'pricePerCredit': 750,
      'totalValue': 375000,
      'status': 'Active',
      'views': 245,
      'inquiries': 12,
      'datePosted': '2024-01-15',
      'validUntil': '2024-06-15',
      'standard': 'VCS',
      'vintage': '2023',
    },
    {
      'id': 'CC002',
      'title': 'Wind Energy Project - Gujarat',
      'credits': 300,
      'pricePerCredit': 800,
      'totalValue': 240000,
      'status': 'Pending',
      'views': 89,
      'inquiries': 5,
      'datePosted': '2024-01-20',
      'validUntil': '2024-07-20',
      'standard': 'Gold Standard',
      'vintage': '2023',
    },
    {
      'id': 'CC003',
      'title': 'Reforestation Project - Himachal',
      'credits': 200,
      'pricePerCredit': 900,
      'totalValue': 180000,
      'status': 'Sold',
      'views': 156,
      'inquiries': 8,
      'datePosted': '2024-01-10',
      'validUntil': '2024-05-10',
      'standard': 'VCS',
      'vintage': '2023',
    },
  ];

  final List<Map<String, dynamic>> _marketTrends = [
    {
      'standard': 'VCS',
      'avgPrice': 750,
      'change': '+5.2%',
      'volume': '12,450',
      'trend': 'up',
    },
    {
      'standard': 'Gold Standard',
      'avgPrice': 820,
      'change': '+3.8%',
      'volume': '8,230',
      'trend': 'up',
    },
    {
      'standard': 'CDM',
      'avgPrice': 680,
      'change': '-1.2%',
      'volume': '5,670',
      'trend': 'down',
    },
    {
      'standard': 'CAR',
      'avgPrice': 790,
      'change': '+2.1%',
      'volume': '3,890',
      'trend': 'up',
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Marketplace'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Listings', icon: Icon(Icons.list_alt)),
            Tab(text: 'Market Trends', icon: Icon(Icons.trending_up)),
            Tab(text: 'Analytics', icon: Icon(Icons.analytics)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyListingsTab(),
          _buildMarketTrendsTab(),
          _buildAnalyticsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateListingDialog(),
        icon: const Icon(Icons.add),
        label: const Text('New Listing'),
      ),
    );
  }

  Widget _buildMyListingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Active Listings',
                  '2',
                  Icons.list_alt,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Total Views',
                  '334',
                  Icons.visibility,
                  AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Inquiries',
                  '17',
                  Icons.message,
                  AppColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Revenue',
                  '₹1,80,000',
                  Icons.account_balance_wallet,
                  AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Listings
          Text(
            'Your Listings',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _myListings.length,
            itemBuilder: (context, index) {
              return _buildListingCard(_myListings[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMarketTrendsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Market Overview',
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
                      Text(
                        'Market Cap',
                        style: AppTextStyles.bodyLarge,
                      ),
                      Text(
                        '₹45.2 Cr',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '24h Volume',
                        style: AppTextStyles.bodyLarge,
                      ),
                      Text(
                        '30,240 Credits',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Price Trends by Standard',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _marketTrends.length,
            itemBuilder: (context, index) {
              return _buildTrendCard(_marketTrends[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Analytics',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          
          // Performance Metrics
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildAnalyticsCard(
                'Avg. Sale Price',
                '₹775',
                Icons.attach_money,
                AppColors.success,
                '+₹25 vs market',
              ),
              _buildAnalyticsCard(
                'Conversion Rate',
                '23.5%',
                Icons.trending_up,
                AppColors.primary,
                '+5.2% this month',
              ),
              _buildAnalyticsCard(
                'Response Time',
                '2.4 hrs',
                Icons.schedule,
                AppColors.info,
                'Faster than 78%',
              ),
              _buildAnalyticsCard(
                'Seller Rating',
                '4.8/5',
                Icons.star,
                AppColors.warning,
                'Based on 24 reviews',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recent Activity
          Text(
            'Recent Activity',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _buildActivityItem(
                  'New inquiry on Solar Farm Credits',
                  '2 hours ago',
                  Icons.message,
                  AppColors.info,
                ),
                const Divider(height: 1),
                _buildActivityItem(
                  'Listing viewed 15 times today',
                  '4 hours ago',
                  Icons.visibility,
                  AppColors.primary,
                ),
                const Divider(height: 1),
                _buildActivityItem(
                  'Price updated for Wind Energy Project',
                  '1 day ago',
                  Icons.edit,
                  AppColors.warning,
                ),
                const Divider(height: 1),
                _buildActivityItem(
                  'Reforestation Project sold successfully',
                  '2 days ago',
                  Icons.check_circle,
                  AppColors.success,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.heading3.copyWith(color: color),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingCard(Map<String, dynamic> listing) {
    Color statusColor = listing['status'] == 'Active' 
        ? AppColors.success 
        : listing['status'] == 'Pending'
            ? AppColors.warning
            : AppColors.textSecondary;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    listing['title'],
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    listing['status'],
                    style: AppTextStyles.caption.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${listing['credits']} Credits',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₹${listing['pricePerCredit']}/credit',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹${listing['totalValue']}',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'Total Value',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.visibility, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${listing['views']} views', style: AppTextStyles.caption),
                const SizedBox(width: 16),
                Icon(Icons.message, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${listing['inquiries']} inquiries', style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => _editListing(listing),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
                TextButton.icon(
                  onPressed: () => _viewListingDetails(listing),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendCard(Map<String, dynamic> trend) {
    Color trendColor = trend['trend'] == 'up' ? AppColors.success : AppColors.error;
    IconData trendIcon = trend['trend'] == 'up' ? Icons.trending_up : Icons.trending_down;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            trend['standard'].substring(0, 2),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(trend['standard']),
        subtitle: Text('Volume: ${trend['volume']} credits'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${trend['avgPrice']}',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(trendIcon, size: 16, color: trendColor),
                Text(
                  trend['change'],
                  style: AppTextStyles.caption.copyWith(color: trendColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color, String subtitle) {
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
                Text(
                  value,
                  style: AppTextStyles.heading3.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium),
      subtitle: Text(time, style: AppTextStyles.caption),
    );
  }

  void _showCreateListingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Listing'),
        content: const Text('Create listing functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create listing feature coming soon!')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _editListing(Map<String, dynamic> listing) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit listing: ${listing['title']}')),
    );
  }

  void _viewListingDetails(Map<String, dynamic> listing) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View details: ${listing['title']}')),
    );
  }
}
