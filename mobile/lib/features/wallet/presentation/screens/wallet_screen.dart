import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:math';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/auth_provider.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  Timer? _priceUpdateTimer;
  bool _isWeeklyView = true;
  double _currentPrice = 10.0; // Starting price for EXC
  double _previousPrice = 10.0;
  List<FlSpot> _priceData = [];
  
  @override
  void initState() {
    super.initState();
    _generateInitialPriceData();
    _startPriceUpdates();
  }
  
  @override
  void dispose() {
    _priceUpdateTimer?.cancel();
    super.dispose();
  }
  
  void _generateInitialPriceData() {
    final random = Random();
    _priceData.clear();
    
    int dataPoints = _isWeeklyView ? 7 : 30;
    double basePrice = 10.0;
    
    for (int i = 0; i < dataPoints; i++) {
      double variation = (random.nextDouble() - 0.5) * 2; // -1 to +1
      basePrice += variation * 0.5; // Max change of 0.5 per point
      basePrice = basePrice.clamp(8.0, 15.0); // Keep price in reasonable range
      _priceData.add(FlSpot(i.toDouble(), basePrice));
    }
    
    _currentPrice = _priceData.last.y;
    _previousPrice = _priceData.length > 1 ? _priceData[_priceData.length - 2].y : _currentPrice;
  }
  
  void _startPriceUpdates() {
    _priceUpdateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _updatePrice();
        });
      }
    });
  }
  
  void _updatePrice() {
    final random = Random();
    _previousPrice = _currentPrice;
    
    // Generate realistic price movement
    double change = (random.nextDouble() - 0.5) * 0.8; // -0.4 to +0.4
    _currentPrice += change;
    _currentPrice = _currentPrice.clamp(8.0, 15.0);
    
    // Update the data array
    _priceData.removeAt(0);
    _priceData.add(FlSpot((_priceData.length).toDouble(), _currentPrice));
    
    // Update x-axis values
    for (int i = 0; i < _priceData.length; i++) {
      _priceData[i] = FlSpot(i.toDouble(), _priceData[i].y);
    }
  }
  
  void _toggleView() {
    setState(() {
      _isWeeklyView = !_isWeeklyView;
      _generateInitialPriceData();
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EXC Wallet'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Balance Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EXC Balance',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '2,450 EXC',
                      style: AppTextStyles.heading1.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '≈ 24,500 INR',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // EXC Price Graph
              _buildPriceGraphCard(),
              const SizedBox(height: 32),
              
              // Quick Actions
              Text(
                'Quick Actions',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.add,
                      title: 'Buy EXC',
                      subtitle: 'Add funds',
                      onTap: () => _showBuyDialog(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.send,
                      title: 'Send EXC',
                      subtitle: 'Transfer coins',
                      onTap: () => _showSendDialog(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Recent Transactions
              Text(
                'Recent Transactions',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildTransactionItem(
                      icon: Icons.add_circle,
                      title: 'Purchased EXC',
                      subtitle: 'Payment via UPI',
                      amount: '+500 EXC',
                      time: '2 hours ago',
                      isCredit: true,
                    ),
                    _buildTransactionItem(
                      icon: Icons.shopping_cart,
                      title: 'Carbon Credit Purchase',
                      subtitle: 'Forest Conservation Project',
                      amount: '-150 EXC',
                      time: '1 day ago',
                      isCredit: false,
                    ),
                    _buildTransactionItem(
                      icon: Icons.add_circle,
                      title: 'Purchased EXC',
                      subtitle: 'Payment via Card',
                      amount: '+1000 EXC',
                      time: '3 days ago',
                      isCredit: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required String time,
    required bool isCredit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isCredit ? AppColors.success : AppColors.error).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isCredit ? AppColors.success : AppColors.error,
              size: 20,
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: isCredit ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  void _showBuyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buy EXC Coins'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select amount to purchase:'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAmountButton('EXC500', '50 EXC'),
                _buildAmountButton('EXC1000', '100 EXC'),
                _buildAmountButton('EXC2000', '200 EXC'),
              ],
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
                const SnackBar(
                  content: Text('EXC purchase successful!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Buy Now'),
          ),
        ],
      ),
    );
  }

  void _showSendDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send EXC Coins'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Recipient Address',
                hintText: 'Enter wallet address',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount (EXC)',
                hintText: 'Enter amount to send',
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
                const SnackBar(
                  content: Text('EXC sent successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountButton(String price, String exc) {
    return Column(
      children: [
        Text(price, style: AppTextStyles.bodyMedium),
        Text(exc, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildPriceGraphCard() {
    final bool isPriceUp = _currentPrice > _previousPrice;
    final double percentChange = _previousPrice != 0 
        ? ((_currentPrice - _previousPrice) / _previousPrice) * 100 
        : 0.0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with price info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXC Price',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'EXC${_currentPrice.toStringAsFixed(2)}',
                    style: AppTextStyles.heading2.copyWith(
                      color: isPriceUp ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        isPriceUp ? Icons.trending_up : Icons.trending_down,
                        color: isPriceUp ? AppColors.success : AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${isPriceUp ? '+' : ''}${percentChange.toStringAsFixed(2)}%',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isPriceUp ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Live',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // View Toggle
          Row(
            children: [
              _buildViewToggle('Weekly', _isWeeklyView),
              const SizedBox(width: 12),
              _buildViewToggle('Monthly', !_isWeeklyView),
            ],
          ),
          const SizedBox(height: 20),
          
          // Price Graph
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          'EXC${value.toInt()}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: _isWeeklyView ? 1 : 5,
                      getTitlesWidget: (value, meta) {
                        if (_isWeeklyView) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          if (value.toInt() < days.length) {
                            return Text(
                              days[value.toInt()],
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            );
                          }
                        } else {
                          return Text(
                            '${value.toInt() + 1}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _priceData,
                    isCurved: true,
                    color: isPriceUp ? AppColors.success : AppColors.error,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: isPriceUp ? AppColors.success : AppColors.error,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: (isPriceUp ? AppColors.success : AppColors.error).withOpacity(0.1),
                    ),
                  ),
                ],
                minY: _priceData.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 0.5,
                maxY: _priceData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle(String title, bool isSelected) {
    return GestureDetector(
      onTap: _toggleView,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
