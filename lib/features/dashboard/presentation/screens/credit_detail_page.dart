import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class CreditDetailPage extends StatelessWidget {
  final String projectName;
  final String sellerName;
  final String price;
  final String location;

  const CreditDetailPage({
    super.key,
    required this.projectName,
    required this.sellerName,
    required this.price,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.eco, color: AppColors.primary, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            projectName,
                            style: AppTextStyles.heading2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      location,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Gold Standard Verified',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Seller Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seller Information',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Icon(Icons.business, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sellerName,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.verified, color: AppColors.success, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Verified Seller',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.warning, size: 20),
                        const SizedBox(width: 4),
                        Text('4.8', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        Text('(127 reviews)', style: AppTextStyles.caption),
                        const Spacer(),
                        Text('Since 2019', style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Project Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Project Details',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Project Type', 'Reforestation'),
                    _buildDetailRow('Verification Standard', 'Gold Standard'),
                    _buildDetailRow('Available Credits', '3,000'),
                    _buildDetailRow('Vintage Year', '2023'),
                    _buildDetailRow('Price per Credit', price),
                    _buildDetailRow('Methodology', 'AR-ACM0003'),
                    _buildDetailRow('Registry', 'Gold Standard Registry'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // About Project
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About the Project',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This project focuses on restoring native forest ecosystems and protecting biodiversity while generating high-quality carbon credits. The initiative involves local communities in sustainable forest management practices and provides economic benefits to rural areas.',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Environmental Benefits:',
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildBenefitItem('Carbon Sequestration', '1 tCO2e per credit'),
                    _buildBenefitItem('Biodiversity Protection', '500+ species protected'),
                    _buildBenefitItem('Soil Conservation', '1000 hectares restored'),
                    _buildBenefitItem('Water Conservation', 'Watershed protection'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to marketplace
                      context.pop();
                    },
                    icon: const Icon(Icons.store),
                    label: const Text('View in Marketplace'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add to cart functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart')),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.success, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text('$title: $description', style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}
