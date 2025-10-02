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
  
  // Form controllers for creating listings
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedStandard = 'VCS';
  String _selectedVintage = '2023';

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
        title: const Text('Seller Marketplace'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateListingDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'My Listings'),
            Tab(text: 'Create Listing'),
            Tab(text: 'Market trends'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildMyListingsTab(),
          _buildCreateListingTab(),
          _buildMarketTrendsTab(),
        ],
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
                  'EXC1,80,000',
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
                        'EXC45.2 Cr',
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
                'EXC775',
                Icons.attach_money,
                AppColors.success,
                '+EXC25 vs market',
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
                        'EXC${listing['pricePerCredit']}/credit',
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
                        'EXC${listing['totalValue']}',
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
              'EXC${trend['avgPrice']}',
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

  Widget _buildCreateListingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create New Credit Listing',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 24),
          
          // Project Title
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Project Title',
              hintText: 'e.g., Solar Farm Credits - Rajasthan',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          
          // Credits Available
          TextField(
            controller: _creditsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Credits Available',
              hintText: 'Number of credits to sell',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          
          // Price per Credit
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Price per Credit (EXC)',
              hintText: 'Price in EXC tokens',
              border: OutlineInputBorder(),
              prefixText: 'EXC ',
            ),
          ),
          const SizedBox(height: 16),
          
          // Standard Dropdown
          DropdownButtonFormField<String>(
            value: _selectedStandard,
            decoration: const InputDecoration(
              labelText: 'Carbon Standard',
              border: OutlineInputBorder(),
            ),
            items: ['VCS', 'Gold Standard', 'CDM', 'CAR'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedStandard = newValue!;
              });
            },
          ),
          const SizedBox(height: 16),
          
          // Vintage Year
          DropdownButtonFormField<String>(
            value: _selectedVintage,
            decoration: const InputDecoration(
              labelText: 'Vintage Year',
              border: OutlineInputBorder(),
            ),
            items: ['2023', '2022', '2021', '2020'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedVintage = newValue!;
              });
            },
          ),
          const SizedBox(height: 16),
          
          // Description
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Project Description',
              hintText: 'Describe your carbon credit project...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          
          // Create Listing Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _createListing,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Create Listing'),
            ),
          ),
          const SizedBox(height: 16),
          
          // Preview Card
          if (_titleController.text.isNotEmpty || _creditsController.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _titleController.text.isEmpty ? 'Project Title' : _titleController.text,
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${_creditsController.text.isEmpty ? '0' : _creditsController.text} Credits',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const Spacer(),
                      Text(
                        'EXC${_priceController.text.isEmpty ? '0' : _priceController.text}/credit',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _selectedStandard,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _selectedVintage,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _createListing() {
    if (_titleController.text.isEmpty || 
        _creditsController.text.isEmpty || 
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }
    
    // Add new listing to the list
    setState(() {
      _myListings.add({
        'id': 'CC${_myListings.length + 1}'.padLeft(5, '0'),
        'title': _titleController.text,
        'credits': int.parse(_creditsController.text),
        'pricePerCredit': int.parse(_priceController.text),
        'totalValue': int.parse(_creditsController.text) * int.parse(_priceController.text),
        'status': 'Active',
        'views': 0,
        'inquiries': 0,
        'datePosted': DateTime.now().toString().substring(0, 10),
        'validUntil': DateTime.now().add(const Duration(days: 180)).toString().substring(0, 10),
        'standard': _selectedStandard,
        'vintage': _selectedVintage,
        'description': _descriptionController.text,
      });
    });
    
    // Clear form
    _titleController.clear();
    _creditsController.clear();
    _priceController.clear();
    _descriptionController.clear();
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Listing created successfully!')),
    );
    
    // Switch to My Listings tab
    _tabController.animateTo(1);
  }

  void _showCreateListingDialog() {
    // Switch to Create Listing tab
    _tabController.animateTo(2);
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
