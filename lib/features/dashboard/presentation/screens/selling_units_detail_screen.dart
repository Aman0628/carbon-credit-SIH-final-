import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class SellingUnitsDetailScreen extends ConsumerWidget {
  final String projectName;
  final String projectType;
  final String location;
  final int totalCredits;
  final int availableCredits;
  final int soldCredits;
  final double pricePerCredit;
  final String status;
  final String lastSale;

  const SellingUnitsDetailScreen({
    super.key,
    required this.projectName,
    required this.projectType,
    required this.location,
    required this.totalCredits,
    required this.availableCredits,
    required this.soldCredits,
    required this.pricePerCredit,
    required this.status,
    required this.lastSale,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soldPercentage = (soldCredits / totalCredits * 100).toInt();
    final revenue = soldCredits * pricePerCredit;

    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Header Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                projectName,
                                style: AppTextStyles.heading2.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$projectType • $location',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            status,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Key Metrics
            Text(
              'Key Metrics',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total Credits',
                    totalCredits.toString(),
                    Icons.inventory,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Available',
                    availableCredits.toString(),
                    Icons.check_circle,
                    AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Sold Credits',
                    soldCredits.toString(),
                    Icons.trending_up,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Total Revenue',
                    '₹${(revenue / 100000).toStringAsFixed(1)}L',
                    Icons.currency_rupee,
                    AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sales Progress
            Text(
              'Sales Progress',
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
                          'Progress: $soldPercentage% Complete',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$soldCredits / $totalCredits',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: soldCredits / totalCredits,
                      backgroundColor: AppColors.divider,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
                      minHeight: 8,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pricing Information
            Text(
              'Pricing Information',
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
                              'Current Price',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              '₹${pricePerCredit.toStringAsFixed(0)}',
                              style: AppTextStyles.heading2.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'per credit',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Last Sale',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              lastSale,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
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

            // Recent Sales History
            Text(
              'Recent Sales History',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  _buildSaleHistoryItem('EcoTech Industries', '50 credits', '₹42,500', '2 days ago'),
                  const Divider(height: 1),
                  _buildSaleHistoryItem('Green Solutions Ltd', '25 credits', '₹21,250', '5 days ago'),
                  const Divider(height: 1),
                  _buildSaleHistoryItem('Carbon Neutral Corp', '75 credits', '₹63,750', '1 week ago'),
                  const Divider(height: 1),
                  _buildSaleHistoryItem('Sustainable Energy Co', '100 credits', '₹85,000', '2 weeks ago'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showUpdatePricingDialog(context),
                    icon: const Icon(Icons.price_change),
                    label: const Text('Update Pricing'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showAnalyticsDialog(context),
                    icon: const Icon(Icons.analytics),
                    label: const Text('View Analytics'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.heading3.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
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

  Widget _buildSaleHistoryItem(String buyer, String credits, String amount, String time) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.success.withOpacity(0.1),
        child: Icon(Icons.person, color: AppColors.success),
      ),
      title: Text(buyer, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text('$credits • $time', style: AppTextStyles.caption),
      trailing: Text(
        amount,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.success,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showUpdatePricingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Pricing'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current price: ₹${pricePerCredit.toStringAsFixed(0)} per credit'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'New Price per Credit',
                prefixText: '₹',
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
                const SnackBar(content: Text('Pricing updated successfully!')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showAnalyticsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Project Analytics'),
        content: const Text(
          'Detailed analytics for this project:\n\n'
          '• Sales performance trends\n'
          '• Revenue growth over time\n'
          '• Buyer demographics\n'
          '• Market price comparisons\n'
          '• Seasonal demand patterns',
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
}
