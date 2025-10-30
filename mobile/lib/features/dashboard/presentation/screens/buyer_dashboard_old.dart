import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/custom_components.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../tools/presentation/screens/tools_screen.dart';
import '../../../marketplace/presentation/screens/buyer_marketplace_screen.dart';

class BuyerDashboard extends ConsumerStatefulWidget {
  const BuyerDashboard({super.key});

  @override
  ConsumerState<BuyerDashboard> createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends ConsumerState<BuyerDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All Types';
  int _currentTransactionIndex = 0;
  Timer? _transactionTimer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentBottomNavIndex = 0;

  final List<Map<String, String>> _recentTransactions = [
    {
      'userName': 'Alex Johnson',
      'credits': '15 credits',
      'projectName': 'Reforestation Himachal',
      'amount': '₹9,750',
      'time': '2 minutes ago',
      'type': 'Purchase'
    },
    {
      'userName': 'Maria Garcia',
      'credits': '30 credits',
      'projectName': 'Sundarbans Mangrove',
      'amount': '₹21,600',
      'time': '5 minutes ago',
      'type': 'Purchase'
    },
    {
      'userName': 'Chen Wei',
      'credits': '25 credits',
      'projectName': 'Amazon Community Forestry',
      'amount': '₹20,000',
      'time': '8 minutes ago',
      'type': 'Purchase'
    },
    {
      'userName': 'Sarah Ahmed',
      'credits': '40 credits',
      'projectName': 'Coastal Mangrove Protection',
      'amount': '₹28,800',
      'time': '12 minutes ago',
      'type': 'Purchase'
    },
    {
      'userName': 'David Kim',
      'credits': '20 credits',
      'projectName': 'Forest Revival Project',
      'amount': '₹14,000',
      'time': '15 minutes ago',
      'type': 'Purchase'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _startTransactionTimer(); // Start timer for the initial tab
  }

  @override
  void dispose() {
    _transactionTimer?.cancel();
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.index == 0) {
      _startTransactionTimer();
    } else {
      _stopTransactionTimer();
    }
  }

  void _startTransactionTimer() {
    if ((_transactionTimer == null || !_transactionTimer!.isActive) && _tabController.index == 0) {
      _transactionTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_scaffoldKey.currentState?.isDrawerOpen == false) {
          setState(() {
            _currentTransactionIndex = (_currentTransactionIndex + 1) % _recentTransactions.length;
          });
        }
      });
    }
  }

  void _stopTransactionTimer() {
    _transactionTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final authState = ref.watch(authProvider);
    final user = authState.user!;
    
    // Determine which content to show based on bottom nav selection
    Widget bodyContent;
    switch (_currentBottomNavIndex) {
      case 0:
        bodyContent = _buildBuyerHomeTab(user);
        break;
      case 1:
        bodyContent = _buildBuyerUPITab(user);
        break;
      case 2:
        bodyContent = _buildBuyerAccountTab(user);
        break;
      default:
        bodyContent = _buildBuyerHomeTab(user);
    }
    
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildSidebar(context, ref, user),
      bottomNavigationBar: _buildNewBottomNavigationBar(context),
      body: SafeArea(
        child: bodyContent,
      ),
    );
  }

  // NEW: Buyer Home Tab Content
  Widget _buildBuyerHomeTab(user) {
    return Column(
          children: [
            // Modern Gradient Header
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                boxShadow: AppShadows.card,
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Profile Avatar with Gradient Background
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState?.openDrawer(),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: AppColors.lightGradient,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                          ),
                          child: Center(
                            child: Text(
                              user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                              style: AppTextStyles.heading3.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // User Info
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _scaffoldKey.currentState?.openDrawer(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back,',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              Text(
                                user.name,
                                style: AppTextStyles.heading3.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              StatusChip(
                                label: 'Verified Buyer',
                                color: AppColors.success,
                                icon: Icons.verified,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // EXC Balance Card
                      GestureDetector(
                        onTap: () => context.push('/wallet'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '2,450',
                                    style: AppTextStyles.heading4.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'EXC Coins',
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 10,
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
            ),
            
            // Enhanced Search Bar
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppShadows.card,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search carbon credits, projects...',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textHint,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppShadows.card,
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Filter functionality
                      },
                      icon: const Icon(
                        Icons.tune,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Modern Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.card,
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: AppColors.primaryGradient,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.all(4),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: AppTextStyles.bodyMedium,
                tabs: const [
                  Tab(text: 'Explore'),
                  Tab(text: 'Portfolio'),
                  Tab(text: 'Marketplace'),
                  Tab(text: 'Certificates'),
                  Tab(text: 'Orders'),
                ],
              ),
            ),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Explore View
                  _buildExploreView(),

                  // Portfolio View
                  _buildPortfolioView(),

                  // Marketplace View
                  _buildMarketplaceView(),

                  // My Certificates View
                  _buildCertificatesView(),

                  // Orders View
                  _buildOrdersView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildExploreView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Most Traded on ECO-Ex Section
          Text(
            'Most Traded on ECO-Ex',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
            children: [
              _buildTradedCreditCard(
                'Sundarbans Mangrove',
                'Coastal Conservation',
                '₹720/credit',
                Icons.eco,
                () => context.push('/credit-detail', extra: {
                  'projectName': 'Sundarbans Mangrove',
                  'sellerName': 'Coastal Conservation',
                  'price': '₹720/credit',
                  'location': 'West Bengal, India',
                }),
              ),
              _buildTradedCreditCard(
                'Amazon Community Forestry',
                'Rainforest Alliance',
                '₹800/credit',
                Icons.forest,
                () => context.push('/credit-detail', extra: {
                  'projectName': 'Amazon Community Forestry',
                  'sellerName': 'Rainforest Alliance',
                  'price': '₹800/credit',
                  'location': 'Amazon, Brazil',
                }),
              ),
              _buildTradedCreditCard(
                'Reforestation Himachal',
                'Forest Revival Co.',
                '₹650/credit',
                Icons.park,
                () => context.push('/credit-detail', extra: {
                  'projectName': 'Reforestation Himachal',
                  'sellerName': 'Forest Revival Co.',
                  'price': '₹650/credit',
                  'location': 'Himachal Pradesh, India',
                }),
              ),
              _buildSeeMoreCard(),
            ],
          ),
          const SizedBox(height: 24),

          // Recent Transactions Section
          Text(
            'Recent Transactions',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _buildRecentTransactionItem(
              _recentTransactions[_currentTransactionIndex],
              key: ValueKey(_currentTransactionIndex),
            ),
          ),
          const SizedBox(height: 24),

          // Tools Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tools & Resources',
                style: AppTextStyles.heading3,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ToolsScreen(),
                    ),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
            children: [
              _buildToolItem('Calculator', Icons.calculate, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CarbonCalculatorScreen(),
                  ),
                );
              }),
              _buildToolItem('News', Icons.newspaper, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MarketNewsScreen(),
                  ),
                );
              }),
              _buildToolItem('UPI Pay', Icons.payment, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UPIPaymentsScreen(),
                  ),
                );
              }),
              _buildToolItem('Reports', Icons.bar_chart, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportsScreen(),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradedCreditCard(String projectName, String sellerName, String price, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.primary, size: 32),
              const Spacer(),
              Text(projectName, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(sellerName, style: AppTextStyles.caption),
              const SizedBox(height: 8),
              Text(price, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeeMoreCard() {
    return GestureDetector(
      onTap: () => _tabController.animateTo(2), // Index 2 is Marketplace
      child: Card(
        color: AppColors.primary.withOpacity(0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_forward, color: AppColors.primary, size: 32),
            const SizedBox(height: 8),
            Text(
              'See More',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolItem(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label, 
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionItem(Map<String, String> transaction, {Key? key}) {
    return GestureDetector(
      key: key,
      onTap: () => _showTransactionDetails(transaction),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                child: Text(transaction['userName']![0]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: transaction['userName']!,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' purchased '),
                          TextSpan(
                            text: transaction['credits']!,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'from ${transaction['projectName']!}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      transaction['time']!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDetails(Map<String, String> transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Transaction Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Buyer', transaction['userName']!),
              _buildDetailRow('Credits', transaction['credits']!),
              _buildDetailRow('Project', transaction['projectName']!),
              _buildDetailRow('Amount', transaction['amount']!),
              _buildDetailRow('Time', transaction['time']!),
              _buildDetailRow('Type', transaction['type']!),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
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
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketTrendsGraph() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Carbon Credit Prices (Last 7 Days)',
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
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
                      Icon(Icons.trending_up, size: 16, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text(
                        '+2.3%',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: CustomPaint(
                painter: SimpleLineChartPainter(),
                size: const Size(double.infinity, 120),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.spaceAround,
              children: [
                _buildPriceIndicator('Forestry', '₹720', AppColors.primary),
                _buildPriceIndicator('Renewable', '₹850', AppColors.success),
                _buildPriceIndicator('Mangrove', '₹680', AppColors.info),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceIndicator(String type, String price, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(type, style: AppTextStyles.caption),
        Text(
          price,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Portfolio Summary Card
          _buildPortfolioSummaryCard(),
          const SizedBox(height: 24),

          // Carbon Footprint Section
          _buildCarbonFootprintCard(),
        ],
      ),
    );
  }

  Widget _buildPortfolioSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Portfolio Summary', style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            _buildSummaryRow('Available Credits', '250', Icons.eco, AppColors.primary),
            const Divider(height: 24),
            _buildSummaryRow('Retired Credits', '125', Icons.verified, AppColors.success),
            const Divider(height: 24),
            _buildSummaryRow('Credits in Cart', '50', Icons.shopping_cart, AppColors.warning),
          ],
        ),
      ),
    );
  }

  Widget _buildCarbonFootprintCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Carbon Footprint', style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            const LinearProgressIndicator(
              value: 0.6,
              minHeight: 12,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            const SizedBox(height: 12),
            const Text('You have offset 60% of your estimated annual carbon footprint.'),
            const SizedBox(height: 16),
            Text(
              'You need 175 more credits to become carbon neutral this year.',
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.bodyLarge),
        const Spacer(),
        Text(value, style: AppTextStyles.heading3.copyWith(color: color)),
      ],
    );
  }

  Widget _buildMarketplaceView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search forest & reforestation credits...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Market Trends Graph
          Text(
            'Market Trends',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          _buildMarketTrendsGraph(),
          const SizedBox(height: 16),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All Types', _selectedFilter == 'All Types'),
                const SizedBox(width: 8),
                _buildFilterChip('Forestry', _selectedFilter == 'Forestry'),
                const SizedBox(width: 8),
                _buildFilterChip('Reforestation', _selectedFilter == 'Reforestation'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Available Credits
          Text(
            'Available Credits',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          
          // Credit Listings
          _buildCreditListing(
            'Sundarbans Mangrove Restoration',
            'West Bengal, India',
            'Coastal Conservation Foundation',
            '₹720/credit',
            '3000 available',
            Icons.eco,
          ),
          const SizedBox(height: 12),
          _buildCreditListing(
            'Amazon Community Forestry',
            'Amazon, Brazil',
            'Rainforest Alliance',
            '₹800/credit',
            '5000 available',
            Icons.forest,
          ),
          const SizedBox(height: 12),
          _buildCreditListing(
            'Reforestation Himachal',
            'Himachal Pradesh, India',
            'Forest Revival Co.',
            '₹650/credit',
            '2000 available',
            Icons.park,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCreditListing(
    String projectName,
    String location,
    String seller,
    String price,
    String available,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () => context.push('/credit-detail', extra: {
        'projectName': projectName,
        'sellerName': seller,
        'price': price,
        'location': location,
      }),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          projectName,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          location,
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Seller Details Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.verified, color: AppColors.success, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Verified Seller',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(seller, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.warning, size: 14),
                        const SizedBox(width: 2),
                        Text('4.8 (127 reviews)', style: AppTextStyles.caption),
                        const SizedBox(width: 12),
                        Icon(Icons.eco, color: AppColors.primary, size: 14),
                        const SizedBox(width: 2),
                        Text('Gold Standard', style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(available, style: AppTextStyles.caption),
                  const Spacer(),
                  Text(
                    price,
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push('/credit-detail', extra: {
                        'projectName': projectName,
                        'sellerName': seller,
                        'price': price,
                        'location': location,
                      }),
                      child: const Text('View Details'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Buy Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _downloadCertificate(String projectName, String credits) {
    // Simulate download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading certificate for $credits from $projectName...'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildCertificatesView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildCertificateSummaryCard(
                  'Total Credits',
                  '375',
                  Icons.eco,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCertificateSummaryCard(
                  'Retired Credits',
                  '125',
                  Icons.verified,
                  AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Transaction History
          Text(
            'Transaction History',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          
          _buildTransactionItem(
            'Purchase',
            'Sundarbans Mangrove Restoration',
            '50 credits',
            '₹36,000',
            '15 Dec 2023',
            Icons.shopping_bag,
            AppColors.success,
          ),
          const SizedBox(height: 8),
          _buildTransactionItem(
            'Retirement',
            'Amazon Community Forestry',
            '25 credits',
            '₹20,000',
            '10 Dec 2023',
            Icons.eco,
            AppColors.primary,
          ),
          const SizedBox(height: 8),
          _buildTransactionItem(
            'Purchase',
            'Reforestation Himachal',
            '75 credits',
            '₹48,750',
            '5 Dec 2023',
            Icons.shopping_bag,
            AppColors.success,
          ),
          const SizedBox(height: 8),
          _buildTransactionItem(
            'Transfer',
            'Forest Revival Project',
            '30 credits',
            '₹21,000',
            '1 Dec 2023',
            Icons.swap_horiz,
            AppColors.warning,
          ),
          const SizedBox(height: 8),
          _buildTransactionItem(
            'Purchase',
            'Coastal Mangrove Protection',
            '100 credits',
            '₹72,000',
            '28 Nov 2023',
            Icons.shopping_bag,
            AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateSummaryCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.heading2.copyWith(color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    String type,
    String projectName,
    String credits,
    String amount,
    String date,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$type - $projectName',
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text('$credits • $date', style: AppTextStyles.caption),
                    ],
                  ),
                ),
                Text(
                  amount,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            if (type == 'Purchase') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/certificate-detail', extra: {
                        'projectName': projectName,
                        'credits': credits,
                        'amount': amount,
                        'date': date,
                      }),
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('View Details'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _downloadCertificate(projectName, credits),
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Download'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Status Summary
          Row(
            children: [
              Expanded(
                child: _buildOrderStatusCard(
                  'Pending',
                  '3',
                  Icons.pending,
                  AppColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildOrderStatusCard(
                  'Completed',
                  '12',
                  Icons.check_circle,
                  AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Recent Orders
          Text(
            'Recent Orders',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          
          _buildOrderItem(
            'ORD-2024-001',
            'Sundarbans Mangrove Restoration',
            '25 credits',
            '₹18,000',
            'Pending',
            '20 Jan 2024',
            AppColors.warning,
          ),
          const SizedBox(height: 8),
          _buildOrderItem(
            'ORD-2024-002',
            'Amazon Community Forestry',
            '50 credits',
            '₹40,000',
            'Processing',
            '18 Jan 2024',
            AppColors.info,
          ),
          const SizedBox(height: 8),
          _buildOrderItem(
            'ORD-2023-045',
            'Reforestation Himachal',
            '30 credits',
            '₹19,500',
            'Completed',
            '15 Jan 2024',
            AppColors.success,
          ),
          const SizedBox(height: 8),
          _buildOrderItem(
            'ORD-2023-044',
            'Coastal Mangrove Protection',
            '75 credits',
            '₹54,000',
            'Completed',
            '12 Jan 2024',
            AppColors.success,
          ),
          const SizedBox(height: 8),
          _buildOrderItem(
            'ORD-2023-043',
            'Forest Revival Project',
            '40 credits',
            '₹28,000',
            'Completed',
            '8 Jan 2024',
            AppColors.success,
          ),
          const SizedBox(height: 8),
          _buildOrderItem(
            'ORD-2023-042',
            'Sundarbans Mangrove Restoration',
            '60 credits',
            '₹43,200',
            'Cancelled',
            '5 Jan 2024',
            AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusCard(
    String label,
    String count,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              count,
              style: AppTextStyles.heading2.copyWith(color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(
    String orderId,
    String projectName,
    String credits,
    String amount,
    String status,
    String date,
    Color statusColor,
  ) {
    return GestureDetector(
      onTap: () => context.push('/order-detail', extra: {
        'orderId': orderId,
        'projectName': projectName,
        'credits': credits,
        'amount': amount,
        'status': status,
        'date': date,
      }),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    orderId,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: AppTextStyles.caption.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                projectName,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.eco, color: AppColors.primary, size: 16),
                  const SizedBox(width: 4),
                  Text(credits, style: AppTextStyles.caption),
                  const SizedBox(width: 16),
                  Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 16),
                  const SizedBox(width: 4),
                  Text(date, style: AppTextStyles.caption),
                  const Spacer(),
                  Text(
                    amount,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push('/order-detail', extra: {
                        'orderId': orderId,
                        'projectName': projectName,
                        'credits': credits,
                        'amount': amount,
                        'status': status,
                        'date': date,
                      }),
                      child: const Text('View Details'),
                    ),
                  ),
                  if (status == 'Pending') ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _cancelOrder(orderId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _cancelOrder(String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Order'),
          content: Text('Are you sure you want to cancel order $orderId?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order $orderId has been cancelled')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNewBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? const Color(0xFF1E1E1E) 
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNewBottomNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: _currentBottomNavIndex == 0,
                onTap: () => setState(() => _currentBottomNavIndex = 0),
              ),
              _buildNewBottomNavItem(
                icon: Icons.account_balance_wallet_rounded,
                label: 'UPI',
                isSelected: _currentBottomNavIndex == 1,
                onTap: () => setState(() => _currentBottomNavIndex = 1),
              ),
              _buildNewBottomNavItem(
                icon: Icons.person_rounded,
                label: 'Account',
                isSelected: _currentBottomNavIndex == 2,
                onTap: () => setState(() => _currentBottomNavIndex = 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewBottomNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF2E7D32); // Green
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? primaryColor.withOpacity(0.1) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: isSelected 
                    ? primaryColor 
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected 
                    ? primaryColor 
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, WidgetRef ref, user) {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Menu',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Account Section
                _buildMenuItem(
                  icon: Icons.person,
                  title: 'Account',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/account');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.account_balance_wallet,
                  title: 'Wallet',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/wallet');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.payment,
                  title: 'Payment Options',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/payment-options');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.shopping_bag,
                  title: 'Orders',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/orders');
                  },
                ),
                const Divider(),
                
                // App Features
                _buildMenuItem(
                  icon: Icons.explore,
                  title: 'Explore',
                  onTap: () {
                    Navigator.pop(context);
                    _tabController.animateTo(0);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.store,
                  title: 'Marketplace',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BuyerMarketplaceScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.verified,
                  title: 'My Certificates',
                  onTap: () {
                    Navigator.pop(context);
                    _tabController.animateTo(3);
                  },
                ),
                const Divider(),
                
                // Additional Features
                _buildMenuItem(
                  icon: Icons.account_balance,
                  title: 'Govt Schemes',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Government schemes coming soon!')),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.newspaper,
                  title: 'News',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('News section coming soon!')),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.public,
                  title: 'International Market',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('International market coming soon!')),
                    );
                  },
                ),
                const Divider(),
                
                // Settings & Support
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/settings');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.contact_support,
                  title: 'Contact Us',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/contact-us');
                  },
                ),
                const Divider(),
                
                // Logout
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(authProvider.notifier).logout();
                    context.go('/');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      onTap: onTap,
    );
  }


}

class SimpleLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Sample data points for the graph
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.8),
      Offset(size.width * 0.3, size.height * 0.4),
      Offset(size.width * 0.45, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.75, size.height * 0.5),
      Offset(size.width, size.height * 0.2),
    ];

    // Create path for the line
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    // Create fill path
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    // Draw fill area
    canvas.drawPath(fillPath, fillPaint);
    
    // Draw line
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
