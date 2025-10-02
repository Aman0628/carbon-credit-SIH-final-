import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/custom_components.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/models/user.dart';
import '../../../tools/presentation/screens/tools_screen.dart';
import '../../../tools/presentation/screens/carbon_calculator_screen.dart' as calc;
import '../../../tools/presentation/screens/market_news_screen.dart' as news;
import 'selling_units_detail_screen.dart';
import 'pricing_tool_screen.dart';
import 'compliance_check_screen.dart';
import 'create_listing_screen.dart';
import 'view_analytics_screen.dart';

class SellerDashboard extends ConsumerStatefulWidget {
  const SellerDashboard({super.key});

  @override
  ConsumerState<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends ConsumerState<SellerDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTransactionIndex = 0;
  Timer? _transactionTimer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showVerificationBanner = true; // Show verification banner by default

  final List<Map<String, String>> _recentSales = [
    {
      'buyerName': 'Green Corp Ltd',
      'credits': '50 credits',
      'projectName': 'Solar Farm Maharashtra',
      'amount': '₹42,500',
      'time': '2 minutes ago',
      'type': 'Sale'
    },
    {
      'buyerName': 'EcoTech Solutions',
      'credits': '25 credits',
      'projectName': 'Wind Energy Gujarat',
      'amount': '₹23,000',
      'time': '5 minutes ago',
      'type': 'Sale'
    },
    {
      'buyerName': 'Sustainable Industries',
      'credits': '75 credits',
      'projectName': 'Reforestation Himachal',
      'amount': '₹48,750',
      'time': '8 minutes ago',
      'type': 'Sale'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _startTransactionTimer();
  }

  @override
  void dispose() {
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
            _currentTransactionIndex = (_currentTransactionIndex + 1) % _recentSales.length;
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
    final authState = ref.watch(authProvider);
    final user = authState.user!;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildSidebar(context, ref, user),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verification Status Banner
            if (_showVerificationBanner) _buildVerificationBanner(),
            
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
                                label: 'Verified Seller',
                                color: AppColors.success,
                                icon: Icons.verified,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // EXC Balance Card
                      GestureDetector(
                        onTap: () => context.go('/wallet'),
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
                          hintText: 'Search projects, credits, buyers...',
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
                  Tab(text: 'Dashboard'),
                  Tab(text: 'Projects'),
                  Tab(text: 'Marketplace'),
                  Tab(text: 'Tools'),
                ],
              ),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Dashboard View
                  _buildDashboardView(),
                  
                  // My Projects View
                  _buildProjectsView(),
                  
                  // Marketplace View
                  _buildMarketplaceView(),
                  
                  // Tools View
                  _buildToolsView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Performance Overview
          Text(
            'Performance Overview',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _tabController.animateTo(1); // Navigate to My Projects tab
                  },
                  child: _buildStatsCard(
                    'My Projects',
                    '5',
                    Icons.eco,
                    AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _tabController.animateTo(2); // Navigate to Marketplace tab
                  },
                  child: _buildStatsCard(
                    'Marketplace',
                    '1,250',
                    Icons.store,
                    AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  'Total Credits',
                  '4,300',
                  Icons.inventory,
                  AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatsCard(
                  'Monthly Revenue',
                  '₹2.4L',
                  Icons.trending_up,
                  AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Market Insights
          Text(
            'Market Insights',
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
                            'Avg Market Price',
                            style: AppTextStyles.bodyMedium,
                          ),
                          Text(
                            '₹775/credit',
                            style: AppTextStyles.heading3.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Your Avg Price',
                            style: AppTextStyles.bodyMedium,
                          ),
                          Text(
                            '₹800/credit',
                            style: AppTextStyles.heading3.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.trending_up, color: AppColors.success, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '+3.2% above market average',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Recent Sales Section
          Text(
            'Recent Sales',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _buildRecentSaleItem(
              _recentSales[_currentTransactionIndex],
              key: ValueKey(_currentTransactionIndex),
            ),
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
          const SizedBox(height: 24),
          
          // Quick Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Actions',
                style: AppTextStyles.heading3,
              ),
              TextButton(
                onPressed: () => _tabController.animateTo(3),
                child: const Text('See All Tools'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildActionCard(
                context: context,
                icon: Icons.add,
                title: 'New Project',
                subtitle: 'Add a new project',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateListingScreen(),
                  ),
                ),
              ),
              _buildActionCard(
                context: context,
                icon: Icons.analytics,
                title: 'View Analytics',
                subtitle: 'Performance insights',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewAnalyticsScreen(),
                  ),
                ),
              ),
              _buildActionCard(
                context: context,
                icon: Icons.calculate,
                title: 'Carbon Calculator',
                subtitle: 'Calculate emissions',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const calc.CarbonCalculatorScreen(),
                  ),
                ),
              ),
              _buildActionCard(
                context: context,
                icon: Icons.insights,
                title: 'Market News',
                subtitle: 'Latest trends',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const news.MarketNewsScreen(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Statistics
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  'Active Projects',
                  '3',
                  Icons.eco,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatsCard(
                  'Total Capacity',
                  '4,300',
                  Icons.battery_charging_full,
                  AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Active Projects
          Text(
            'Active Projects',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _buildProjectItem(
                  'Solar Farm Maharashtra',
                  'Renewable Energy • 1,500 credits',
                  '₹850/credit',
                  'Active',
                  AppColors.success,
                  Icons.wb_sunny,
                ),
                const Divider(height: 1),
                _buildProjectItem(
                  'Wind Energy Gujarat',
                  'Renewable Energy • 800 credits',
                  '₹920/credit',
                  'Active',
                  AppColors.success,
                  Icons.air,
                ),
                const Divider(height: 1),
                _buildProjectItem(
                  'Reforestation Himachal',
                  'Forestry • 2,000 credits',
                  '₹650/credit',
                  'Active',
                  AppColors.success,
                  Icons.forest,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Add New Project Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateListingScreen(),
                  ),
                ),
              icon: const Icon(Icons.add),
              label: const Text('Add New Project'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketplaceView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selling Units & Credit Details Project-wise
          Text(
            'My Credit Listings',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          
          // Project 1 - Solar Farm Maharashtra
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SellingUnitsDetailScreen(
                  projectName: 'Solar Farm Maharashtra',
                  projectType: 'Renewable Energy',
                  location: 'Maharashtra, India',
                  totalCredits: 1500,
                  availableCredits: 1200,
                  soldCredits: 300,
                  pricePerCredit: 850.0,
                  status: 'Active',
                  lastSale: '2 days ago',
                ),
              ),
            ),
            child: _buildProjectCreditCard(
              projectName: 'Solar Farm Maharashtra',
              projectType: 'Renewable Energy',
              location: 'Maharashtra, India',
              totalCredits: 1500,
              availableCredits: 1200,
              soldCredits: 300,
              pricePerCredit: 850.0,
              status: 'Active',
              lastSale: '2 days ago',
            ),
          ),
          const SizedBox(height: 12),
          
          // Project 2 - Wind Energy Gujarat  
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SellingUnitsDetailScreen(
                  projectName: 'Wind Energy Gujarat',
                  projectType: 'Renewable Energy',
                  location: 'Gujarat, India',
                  totalCredits: 800,
                  availableCredits: 650,
                  soldCredits: 150,
                  pricePerCredit: 920.0,
                  status: 'Active',
                  lastSale: '5 days ago',
                ),
              ),
            ),
            child: _buildProjectCreditCard(
              projectName: 'Wind Energy Gujarat',
              projectType: 'Renewable Energy',
              location: 'Gujarat, India',
              totalCredits: 800,
              availableCredits: 650,
              soldCredits: 150,
              pricePerCredit: 920.0,
              status: 'Active',
              lastSale: '5 days ago',
            ),
          ),
          const SizedBox(height: 12),
          
          // Project 3 - Reforestation Project
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SellingUnitsDetailScreen(
                  projectName: 'Reforestation Himachal',
                  projectType: 'Forestry',
                  location: 'Himachal Pradesh, India',
                  totalCredits: 2000,
                  availableCredits: 1800,
                  soldCredits: 200,
                  pricePerCredit: 650.0,
                  status: 'Active',
                  lastSale: '1 week ago',
                ),
              ),
            ),
            child: _buildProjectCreditCard(
              projectName: 'Reforestation Himachal',
              projectType: 'Forestry',
              location: 'Himachal Pradesh, India',
              totalCredits: 2000,
              availableCredits: 1800,
              soldCredits: 200,
              pricePerCredit: 650.0,
              status: 'Active',
              lastSale: '1 week ago',
            ),
          ),
          const SizedBox(height: 32),

          // Market Trends (moved to bottom)
          Text(
            'Market Trends',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _buildTrendItem('VCS Credits', '₹775', '+5.2%', true),
                const Divider(height: 1),
                _buildTrendItem('Gold Standard', '₹820', '+3.8%', true),
                const Divider(height: 1),
                _buildTrendItem('CDM Credits', '₹680', '-1.2%', false),
                const Divider(height: 1),
                _buildTrendItem('CAR Credits', '₹790', '+2.1%', true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seller Tools & Resources',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 8),
          Text(
            'Essential tools for carbon credit sellers',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Tools Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: [
              _buildToolCard(
                'Project Calculator',
                'Calculate project viability',
                Icons.calculate,
                AppColors.primary,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const calc.CarbonCalculatorScreen(),
                  ),
                ),
              ),
              _buildToolCard(
                'Market Insights',
                'Latest market trends',
                Icons.insights,
                AppColors.info,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const news.MarketNewsScreen(),
                  ),
                ),
              ),
              _buildToolCard(
                'Pricing Tool',
                'Optimize your pricing',
                Icons.price_change,
                AppColors.success,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PricingToolScreen(),
                  ),
                ),
              ),
              _buildToolCard(
                'Compliance Check',
                'Verify project compliance',
                Icons.verified_user,
                AppColors.warning,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ComplianceCheckScreen(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // View All Tools Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ToolsScreen(),
                ),
              ),
              icon: const Icon(Icons.build),
              label: const Text('View All Tools'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(
              icon: Icons.person,
              label: 'Account',
              onTap: () => context.push('/account'),
            ),
            _buildBottomNavItem(
              icon: Icons.account_balance_wallet,
              label: 'Wallet',
              onTap: () => context.push('/wallet'),
            ),
            _buildBottomNavItem(
              icon: Icons.newspaper,
              label: 'News',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const news.MarketNewsScreen(),
                ),
              ),
            ),
            _buildBottomNavItem(
              icon: Icons.payment,
              label: 'UPI',
              onTap: () => context.push('/payment-options'),
            ),
            _buildBottomNavItem(
              icon: Icons.support_agent,
              label: 'Support',
              onTap: () => context.push('/contact-us'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontSize: 10,
              ),
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
                
                // Seller Features
                _buildMenuItem(
                  icon: Icons.eco,
                  title: 'My Projects',
                  onTap: () {
                    Navigator.pop(context);
                    _tabController.animateTo(1);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.store,
                  title: 'Marketplace',
                  onTap: () {
                    Navigator.pop(context);
                    _tabController.animateTo(2);
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


  Widget _buildStatsCard(String title, String value, IconData icon, Color color) {
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

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // New helper methods for seller dashboard
  Widget _buildRecentSaleItem(Map<String, String> sale, {Key? key}) {
    return GestureDetector(
      key: key,
      onTap: () => _showSaleDetails(sale),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.success.withOpacity(0.1),
                child: Icon(Icons.trending_up, color: AppColors.success),
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
                            text: sale['buyerName']!,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' bought '),
                          TextSpan(
                            text: sale['credits']!,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'from ${sale['projectName']!}',
                      style: AppTextStyles.caption,
                    ),
                    Text(
                      sale['time']!,
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    sale['amount']!,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectItem(String title, String subtitle, String price, String status, Color statusColor, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withOpacity(0.1),
        child: Icon(icon, color: statusColor),
      ),
      title: Text(title, style: AppTextStyles.bodyLarge),
      subtitle: Text(subtitle, style: AppTextStyles.bodyMedium),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            price,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: AppTextStyles.caption.copyWith(color: statusColor),
            ),
          ),
        ],
      ),
      onTap: () => _showProjectDetails(title),
    );
  }


  Widget _buildToolCard(String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  void _showSaleDetails(Map<String, String> sale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sale Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Buyer', sale['buyerName']!),
            _buildDetailRow('Credits', sale['credits']!),
            _buildDetailRow('Project', sale['projectName']!),
            _buildDetailRow('Amount', sale['amount']!),
            _buildDetailRow('Time', sale['time']!),
            _buildDetailRow('Type', sale['type']!),
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

  void _showProjectDetails(String projectName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(projectName),
        content: const Text(
          'Project details including certification status, '
          'available credits, pricing history, and buyer feedback.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('View Full Details'),
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
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
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
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Activity: $title')),
      ),
    );
  }

  Widget _buildTrendItem(String standard, String price, String change, bool isPositive) {
    Color trendColor = isPositive ? AppColors.success : AppColors.error;
    IconData trendIcon = isPositive ? Icons.trending_up : Icons.trending_down;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: Text(
          standard.substring(0, 2),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(standard, style: AppTextStyles.bodyMedium),
      subtitle: Text('Market average', style: AppTextStyles.caption),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            price,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(trendIcon, size: 16, color: trendColor),
              Text(
                change,
                style: AppTextStyles.caption.copyWith(color: trendColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCreditCard({
    required String projectName,
    required String projectType,
    required String location,
    required int totalCredits,
    required int availableCredits,
    required int soldCredits,
    required double pricePerCredit,
    required String status,
    required String lastSale,
  }) {
    final soldPercentage = (soldCredits / totalCredits * 100).toInt();
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        projectName,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$projectType • $location',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Credit Statistics
            Row(
              children: [
                Expanded(
                  child: _buildCreditStat('Total Credits', totalCredits.toString(), Icons.inventory),
                ),
                Expanded(
                  child: _buildCreditStat('Available', availableCredits.toString(), Icons.check_circle),
                ),
                Expanded(
                  child: _buildCreditStat('Sold', soldCredits.toString(), Icons.trending_up),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sales Progress',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '$soldPercentage% sold',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: soldCredits / totalCredits,
                  backgroundColor: AppColors.divider,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Price and Last Sale
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price per Credit',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '₹${pricePerCredit.toStringAsFixed(0)}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Last Sale',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      lastSale,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildCreditStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: AppColors.warning.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.hourglass_empty,
            color: AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Verification under process - You will be notified once verified',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _showVerificationBanner = false;
              });
            },
            icon: Icon(
              Icons.close,
              color: AppColors.warning,
              size: 18,
            ),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
