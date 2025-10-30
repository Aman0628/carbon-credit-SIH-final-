import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class BuyerMarketplaceScreen extends ConsumerStatefulWidget {
  const BuyerMarketplaceScreen({super.key});

  @override
  ConsumerState<BuyerMarketplaceScreen> createState() => _BuyerMarketplaceScreenState();
}

class _BuyerMarketplaceScreenState extends ConsumerState<BuyerMarketplaceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  String _sortBy = 'Price: Low to High';

  final List<String> _filters = ['All', 'VCS', 'Gold Standard', 'CDM', 'CAR'];
  final List<String> _sortOptions = [
    'Price: Low to High',
    'Price: High to Low',
    'Credits: Low to High',
    'Credits: High to Low',
    'Newest First',
    'Rating: High to Low',
  ];

  final List<Map<String, dynamic>> _availableCredits = [
    {
      'id': 'CC001',
      'title': 'Solar Farm Credits - Rajasthan',
      'seller': 'GreenTech Solutions',
      'sellerRating': 4.8,
      'credits': 500,
      'pricePerCredit': 750,
      'totalValue': 375000,
      'standard': 'VCS',
      'vintage': '2023',
      'location': 'Rajasthan, India',
      'projectType': 'Solar Energy',
      'verified': true,
      'description': 'High-quality solar energy credits from certified solar farm project in Rajasthan.',
      'images': ['solar1.jpg', 'solar2.jpg'],
      'validUntil': '2024-12-31',
      'addedDate': '2024-01-15',
    },
    {
      'id': 'CC002',
      'title': 'Wind Energy Project - Gujarat',
      'seller': 'WindPower India',
      'sellerRating': 4.6,
      'credits': 300,
      'pricePerCredit': 800,
      'totalValue': 240000,
      'standard': 'Gold Standard',
      'vintage': '2023',
      'location': 'Gujarat, India',
      'projectType': 'Wind Energy',
      'verified': true,
      'description': 'Premium wind energy credits from large-scale wind farm in Gujarat.',
      'images': ['wind1.jpg', 'wind2.jpg'],
      'validUntil': '2024-11-30',
      'addedDate': '2024-01-20',
    },
    {
      'id': 'CC003',
      'title': 'Reforestation Project - Himachal',
      'seller': 'Forest Carbon Ltd',
      'sellerRating': 4.9,
      'credits': 200,
      'pricePerCredit': 900,
      'totalValue': 180000,
      'standard': 'VCS',
      'vintage': '2023',
      'location': 'Himachal Pradesh, India',
      'projectType': 'Reforestation',
      'verified': true,
      'description': 'Nature-based carbon credits from reforestation project in Himachal Pradesh.',
      'images': ['forest1.jpg', 'forest2.jpg'],
      'validUntil': '2025-01-31',
      'addedDate': '2024-01-10',
    },
    {
      'id': 'CC004',
      'title': 'Biogas Plant - Maharashtra',
      'seller': 'BioEnergy Corp',
      'sellerRating': 4.5,
      'credits': 150,
      'pricePerCredit': 720,
      'totalValue': 108000,
      'standard': 'CDM',
      'vintage': '2023',
      'location': 'Maharashtra, India',
      'projectType': 'Biogas',
      'verified': true,
      'description': 'Sustainable biogas project converting agricultural waste to clean energy.',
      'images': ['biogas1.jpg', 'biogas2.jpg'],
      'validUntil': '2024-10-31',
      'addedDate': '2024-01-25',
    },
  ];

  final List<Map<String, dynamic>> _featuredProjects = [
    {
      'title': 'Mega Solar Initiative',
      'location': 'Rajasthan',
      'credits': '10,000+',
      'price': 'EXC650/credit',
      'image': 'mega_solar.jpg',
      'badge': 'Featured',
    },
    {
      'title': 'Coastal Wind Farm',
      'location': 'Tamil Nadu',
      'credits': '5,000+',
      'price': 'EXC780/credit',
      'image': 'coastal_wind.jpg',
      'badge': 'New',
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

  List<Map<String, dynamic>> _getFilteredAndSortedCredits() {
    List<Map<String, dynamic>> filteredCredits = _availableCredits;
    
    // Apply filter
    if (_selectedFilter != 'All') {
      filteredCredits = _availableCredits.where((credit) => 
        credit['standard'] == _selectedFilter
      ).toList();
    }
    
    // Apply sorting
    switch (_sortBy) {
      case 'Price: Low to High':
        filteredCredits.sort((a, b) => a['pricePerCredit'].compareTo(b['pricePerCredit']));
        break;
      case 'Price: High to Low':
        filteredCredits.sort((a, b) => b['pricePerCredit'].compareTo(a['pricePerCredit']));
        break;
      case 'Credits: Low to High':
        filteredCredits.sort((a, b) => a['credits'].compareTo(b['credits']));
        break;
      case 'Credits: High to Low':
        filteredCredits.sort((a, b) => b['credits'].compareTo(a['credits']));
        break;
      case 'Newest First':
        filteredCredits.sort((a, b) => b['addedDate'].compareTo(a['addedDate']));
        break;
      case 'Rating: High to Low':
        filteredCredits.sort((a, b) => b['sellerRating'].compareTo(a['sellerRating']));
        break;
    }
    
    return filteredCredits;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Credit Marketplace'),
        actions: [
          IconButton(
            onPressed: () => _showSearchDialog(),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => _showFilterDialog(),
            icon: const Icon(Icons.filter_list),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Browse', icon: Icon(Icons.store)),
            Tab(text: 'Featured', icon: Icon(Icons.star)),
            Tab(text: 'Watchlist', icon: Icon(Icons.bookmark)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBrowseTab(),
          _buildFeaturedTab(),
          _buildWatchlistTab(),
        ],
      ),
    );
  }

  Widget _buildBrowseTab() {
    return Column(
      children: [
        // Filter and Sort Bar
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      bool isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                onSelected: (value) {
                  setState(() {
                    _sortBy = value;
                  });
                },
                itemBuilder: (context) => _sortOptions.map((option) {
                  return PopupMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sort, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Sort',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Credits List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _getFilteredAndSortedCredits().length,
            itemBuilder: (context, index) {
              return _buildCreditCard(_getFilteredAndSortedCredits()[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Projects',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _featuredProjects.length,
              itemBuilder: (context, index) {
                return _buildFeaturedCard(_featuredProjects[index]);
              },
            ),
          ),
          const SizedBox(height: 24),
          
          Text(
            'Premium Listings',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2, // Show only first 2 premium listings
            itemBuilder: (context, index) {
              return _buildCreditCard(_availableCredits[index], isPremium: true);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlistTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Watchlist',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2, // Show watchlisted items
            itemBuilder: (context, index) {
              return _buildCreditCard(_availableCredits[index], isWatchlisted: true);
            },
          ),
          const SizedBox(height: 24),
          
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Add more credits to your watchlist',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _tabController.animateTo(0),
                  child: const Text('Browse Credits'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCard(Map<String, dynamic> credit, {bool isPremium = false, bool isWatchlisted = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isPremium ? 4 : 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isPremium) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.warning,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'PREMIUM',
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (credit['verified']) ...[
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Expanded(
                            child: Text(
                              credit['title'],
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            credit['seller'],
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 14,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                credit['sellerRating'].toString(),
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _toggleWatchlist(credit),
                  icon: Icon(
                    isWatchlisted ? Icons.bookmark : Icons.bookmark_border,
                    color: isWatchlisted ? AppColors.primary : AppColors.textSecondary,
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
                        '${credit['credits']} Credits',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        credit['projectType'],
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
                        'EXC${credit['pricePerCredit']}/credit',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        credit['location'],
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    credit['standard'],
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Vintage ${credit['vintage']}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.info,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Text(
              credit['description'],
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: EXC${credit['totalValue']}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => _viewCreditDetails(credit),
                      child: const Text('View Details'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _buyCreditDialog(credit),
                      child: const Text('Buy Now'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> project) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.eco,
                      size: 48,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        project['badge'],
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project['title'],
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project['location'],
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        project['credits'],
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        project['price'],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Credits'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Search by project, location, or seller...',
            prefixIcon: Icon(Icons.search),
          ),
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
                const SnackBar(content: Text('Search functionality coming soon!')),
              );
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Advanced Filters'),
        content: const Text('Advanced filtering options will be available here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Advanced filters coming soon!')),
              );
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _toggleWatchlist(Map<String, dynamic> credit) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${credit['title']} added to watchlist')),
    );
  }

  void _viewCreditDetails(Map<String, dynamic> credit) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View details: ${credit['title']}')),
    );
  }

  void _buyCreditDialog(Map<String, dynamic> credit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buy ${credit['title']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Credits: ${credit['credits']}'),
            Text('Price per credit: EXC${credit['pricePerCredit']}'),
            Text('Total: EXC${credit['totalValue']}'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Quantity to buy',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
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
                const SnackBar(content: Text('Purchase functionality coming soon!')),
              );
            },
            child: const Text('Buy Now'),
          ),
        ],
      ),
    );
  }
}
