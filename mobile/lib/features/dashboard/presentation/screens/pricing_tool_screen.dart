import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class PricingToolScreen extends ConsumerStatefulWidget {
  const PricingToolScreen({super.key});

  @override
  ConsumerState<PricingToolScreen> createState() => _PricingToolScreenState();
}

class _PricingToolScreenState extends ConsumerState<PricingToolScreen> {
  String selectedProjectType = 'Renewable Energy';
  String selectedLocation = 'Maharashtra';
  double currentPrice = 850.0;

  final List<String> projectTypes = [
    'Renewable Energy',
    'Forestry',
    'Reforestation',
    'Energy Efficiency',
    'Waste Management',
  ];

  final List<String> locations = [
    'Maharashtra',
    'Gujarat',
    'Karnataka',
    'Tamil Nadu',
    'Rajasthan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pricing Optimization Tool'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Market Analysis
            Text(
              'Market Analysis',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildMarketMetric(
                            'Market Average',
                            '₹775',
                            Icons.trending_flat,
                            AppColors.info,
                          ),
                        ),
                        Expanded(
                          child: _buildMarketMetric(
                            'Your Price',
                            '₹${currentPrice.toStringAsFixed(0)}',
                            Icons.local_offer,
                            AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMarketMetric(
                            'Recommended',
                            '₹820',
                            Icons.recommend,
                            AppColors.success,
                          ),
                        ),
                        Expanded(
                          child: _buildMarketMetric(
                            'Potential Gain',
                            '+5.9%',
                            Icons.trending_up,
                            AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Project Configuration
            Text(
              'Project Configuration',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Project Type',
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedProjectType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: projectTypes.map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedProjectType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Location',
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedLocation,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: locations.map((location) {
                        return DropdownMenuItem(value: location, child: Text(location));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pricing Recommendations
            Text(
              'Pricing Recommendations',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  _buildPricingRecommendation(
                    'Conservative',
                    '₹780',
                    'Safe pricing with steady demand',
                    AppColors.info,
                    Icons.security,
                  ),
                  const Divider(height: 1),
                  _buildPricingRecommendation(
                    'Optimal',
                    '₹820',
                    'Best balance of price and demand',
                    AppColors.success,
                    Icons.star,
                  ),
                  const Divider(height: 1),
                  _buildPricingRecommendation(
                    'Aggressive',
                    '₹860',
                    'Higher margins, lower volume',
                    AppColors.warning,
                    Icons.trending_up,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Market Factors
            Text(
              'Market Factors',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildFactorItem('Demand Trend', 'High', AppColors.success, Icons.trending_up),
                    const SizedBox(height: 12),
                    _buildFactorItem('Competition', 'Medium', AppColors.warning, Icons.people),
                    const SizedBox(height: 12),
                    _buildFactorItem('Seasonality', 'Peak Season', AppColors.info, Icons.calendar_today),
                    const SizedBox(height: 12),
                    _buildFactorItem('Certification', 'Premium', AppColors.success, Icons.verified),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _applyRecommendedPricing(),
                    icon: const Icon(Icons.check),
                    label: const Text('Apply Optimal Pricing'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showCustomPricingDialog(),
                    icon: const Icon(Icons.edit),
                    label: const Text('Custom Price'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketMetric(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
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
    );
  }

  Widget _buildPricingRecommendation(String strategy, String price, String description, Color color, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Row(
        children: [
          Text(strategy, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(
            price,
            style: AppTextStyles.bodyLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      subtitle: Text(description, style: AppTextStyles.caption),
      onTap: () => _selectPricing(strategy, price),
    );
  }

  Widget _buildFactorItem(String factor, String status, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            factor,
            style: AppTextStyles.bodyMedium,
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

  void _selectPricing(String strategy, String price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Apply $strategy Pricing'),
        content: Text('Set your credit price to $price per credit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$strategy pricing applied: $price per credit')),
              );
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _applyRecommendedPricing() {
    _selectPricing('Optimal', '₹820');
  }

  void _showCustomPricingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Pricing'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Price per Credit',
                prefixText: '₹',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Text(
              'Market range: ₹650 - ₹920',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
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
                const SnackBar(content: Text('Custom pricing applied successfully!')),
              );
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
