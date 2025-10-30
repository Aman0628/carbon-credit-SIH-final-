import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/widgets/universal_bottom_nav.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  String _selectedTimeframe = 'Monthly'; // Monthly or Weekly
  
  // Sample data - replace with actual data from provider
  final double _totalValue = 245000;
  final double _totalInvested = 180000;
  final double _profitLoss = 65000;
  final double _percentageChange = 36.11;
  final int _availableCredits = 125;
  final int _retiredCredits = 125;
  
  final List<Map<String, dynamic>> _projects = [
    {
      'name': 'Sundarbans Mangrove',
      'credits': 50,
      'value': 42000,
      'invested': 36000,
      'profit': 6000,
      'percentage': 16.67,
    },
    {
      'name': 'Amazon Forestry',
      'credits': 75,
      'value': 68000,
      'invested': 60000,
      'profit': 8000,
      'percentage': 13.33,
    },
    {
      'name': 'Himalayan Reforestation',
      'credits': 100,
      'value': 135000,
      'invested': 84000,
      'profit': 51000,
      'percentage': 60.71,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isProfit = _profitLoss >= 0;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Portfolio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profit/Loss Header - Minimal without background
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${isProfit ? '+' : ''}EXC${_profitLoss.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: isProfit ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isProfit ? Icons.trending_up : Icons.trending_down,
                    color: isProfit ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                    size: 28,
                  ),
                ],
              ),
            ),

            // Timeframe Selector
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTimeframeButton('Weekly'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTimeframeButton('Monthly'),
                  ),
                ],
              ),
            ),

            // EXCoin Holdings Performance Graph
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                    Text(
                      'EXCoin Holdings Performance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: _buildPerformanceChart(isProfit),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Portfolio Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                    Text(
                      'Portfolio Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            'Total Value',
                            'EXC${_totalValue.toStringAsFixed(0)}',
                            Icons.account_balance_wallet,
                            const Color(0xFF2E7D32),
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                            'Total Invested',
                            'EXC${_totalInvested.toStringAsFixed(0)}',
                            Icons.trending_up,
                            const Color(0xFF1976D2),
                            isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            'Available Credits',
                            _availableCredits.toString(),
                            Icons.eco,
                            const Color(0xFF388E3C),
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                            'Retired Credits',
                            _retiredCredits.toString(),
                            Icons.verified,
                            const Color(0xFF0288D1),
                            isDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Investments List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Your Investments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _projects.length,
              itemBuilder: (context, index) {
                return _buildProjectCard(_projects[index], isDark);
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: UniversalBottomNav(
        currentRoute: '/portfolio',
        isBuyer: true,
      ),
    );
  }

  Widget _buildTimeframeButton(String label) {
    final isSelected = _selectedTimeframe == label;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedTimeframe = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceChart(bool isProfit) {
    // Sample data with fluctuations - X-axis at middle (0 value)
    final spots = _selectedTimeframe == 'Monthly'
        ? [
            const FlSpot(0, 0),      // Start at 0
            const FlSpot(1, 5000),   // Small gain
            const FlSpot(2, -8000),  // Loss
            const FlSpot(3, 15000),  // Recovery
            const FlSpot(4, 12000),  // Small dip
            const FlSpot(5, 35000),  // Big gain
            const FlSpot(6, 65000),  // Final profit
          ]
        : [
            const FlSpot(0, 35000),  // Start higher
            const FlSpot(1, 38000),  // Gain
            const FlSpot(2, 32000),  // Dip
            const FlSpot(3, 45000),  // Recovery
            const FlSpot(4, 50000),  // Gain
            const FlSpot(5, 58000),  // Gain
            const FlSpot(6, 65000),  // Final profit
          ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20000,
          getDrawingHorizontalLine: (value) {
            // Highlight the zero line
            if (value == 0) {
              return FlLine(
                color: Colors.grey.withOpacity(0.5),
                strokeWidth: 2,
              );
            }
            return FlLine(
              color: Colors.grey.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  value == 0 ? '0' : 'EXC${(value / 1000).toStringAsFixed(0)}K',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: value == 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (_selectedTimeframe == 'Monthly') {
                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
                  if (value.toInt() < months.length) {
                    return Text(
                      months[value.toInt()],
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    );
                  }
                } else {
                  const weeks = ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7'];
                  if (value.toInt() < weeks.length) {
                    return Text(
                      weeks[value.toInt()],
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    );
                  }
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: -20000,  // Allow negative values
        maxY: 80000,   // Higher max for growth
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFF2E7D32),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                // Color dots based on positive/negative
                final dotColor = spot.y >= 0 
                    ? const Color(0xFF2E7D32) 
                    : const Color(0xFFD32F2F);
                return FlDotCirclePainter(
                  radius: 4,
                  color: dotColor,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project, bool isDark) {
    final isProfit = project['profit'] >= 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  project['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${project['credits']} Credits',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Value',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'EXC${project['value']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invested',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'EXC${project['invested']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Profit/Loss',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 14,
                        color: isProfit ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'EXC${project['profit']}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isProfit ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${isProfit ? '+' : ''}${project['percentage'].toStringAsFixed(1)}%)',
                        style: TextStyle(
                          fontSize: 12,
                          color: isProfit ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
