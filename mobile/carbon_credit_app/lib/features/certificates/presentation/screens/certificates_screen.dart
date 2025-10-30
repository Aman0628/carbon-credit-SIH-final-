import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/auth_provider.dart';

class CertificatesScreen extends ConsumerWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Certificates'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard/buyer'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portfolio Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portfolio Summary',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryItem(
                            'Total Credits',
                            '125',
                            Icons.eco,
                            AppColors.primary,
                          ),
                        ),
                        Expanded(
                          child: _buildSummaryItem(
                            'Retired Credits',
                            '75',
                            Icons.check_circle,
                            AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryItem(
                            'CO₂ Offset',
                            '125 tons',
                            Icons.cloud_off,
                            AppColors.info,
                          ),
                        ),
                        Expanded(
                          child: _buildSummaryItem(
                            'Portfolio Value',
                            '₹93,750',
                            Icons.account_balance_wallet,
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
            
            // Certificates List
            Text(
              'My Certificates',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            
            // Mock certificates
            _buildCertificateCard(
              'Solar Farm Maharashtra',
              'Renewable Energy',
              50,
              25,
              DateTime(2024, 1, 15),
              'Active',
            ),
            _buildCertificateCard(
              'Wind Energy Gujarat',
              'Renewable Energy',
              30,
              30,
              DateTime(2024, 2, 20),
              'Retired',
            ),
            _buildCertificateCard(
              'Reforestation Himachal',
              'Forestry',
              45,
              20,
              DateTime(2024, 3, 10),
              'Active',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.heading3.copyWith(color: color),
        ),
        Text(
          label,
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCertificateCard(
    String projectName,
    String projectType,
    int totalCredits,
    int retiredCredits,
    DateTime purchaseDate,
    String status,
  ) {
    final isRetired = status == 'Retired';
    final statusColor = isRetired ? AppColors.success : AppColors.primary;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        projectType,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
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
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Credits: $totalCredits',
                        style: AppTextStyles.bodyMedium,
                      ),
                      Text(
                        'Retired: $retiredCredits',
                        style: AppTextStyles.bodyMedium,
                      ),
                      Text(
                        'Available: ${totalCredits - retiredCredits}',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Purchased',
                      style: AppTextStyles.caption,
                    ),
                    Text(
                      '${purchaseDate.day}/${purchaseDate.month}/${purchaseDate.year}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showDownloadDialog(),
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: !isRetired && (totalCredits - retiredCredits) > 0
                        ? () => _showRetireDialog(projectName, totalCredits - retiredCredits)
                        : null,
                    icon: const Icon(Icons.eco),
                    label: const Text('Retire'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDownloadDialog() {
    // Mock download functionality
  }

  void _showRetireDialog(String projectName, int availableCredits) {
    // Mock retire functionality
  }
}
