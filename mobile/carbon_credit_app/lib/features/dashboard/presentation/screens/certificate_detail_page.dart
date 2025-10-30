import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class CertificateDetailPage extends StatelessWidget {
  final String projectName;
  final String credits;
  final String amount;
  final String date;

  const CertificateDetailPage({
    super.key,
    required this.projectName,
    required this.credits,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final certificateId = 'CERT-2023-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () => _downloadCertificate(context),
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Certificate Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.card_membership, color: AppColors.primary, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Carbon Credit Certificate',
                                style: AppTextStyles.heading2,
                              ),
                              Text(
                                certificateId,
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
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'ACTIVE',
                            style: AppTextStyles.caption.copyWith(
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
            const SizedBox(height: 16),

            // Certificate Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Certificate Information',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Project Name', projectName),
                    _buildDetailRow('Credits Purchased', credits),
                    _buildDetailRow('Amount Paid', amount),
                    _buildDetailRow('Purchase Date', date),
                    _buildDetailRow('Certificate ID', certificateId),
                    _buildDetailRow('Verification Standard', 'Gold Standard'),
                    _buildDetailRow('Vintage Year', '2023'),
                    _buildDetailRow('Registry', 'Gold Standard Registry'),
                    _buildDetailRow('Serial Numbers', 'GS1-1-IN-GS7765-1-2023-0001-0050-01'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Environmental Impact
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Environmental Impact',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.eco, color: AppColors.success, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                'Carbon Offset Achieved',
                                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            credits.replaceAll(' credits', ' tonnes of CO2 equivalent'),
                            style: AppTextStyles.heading2.copyWith(color: AppColors.success),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This certificate represents verified carbon sequestration through forest restoration and conservation activities. The credits have been independently verified and registered according to international standards.',
                      style: AppTextStyles.bodyMedium,
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
                    _buildDetailRow('Location', 'West Bengal, India'),
                    _buildDetailRow('Project Developer', 'Coastal Conservation Foundation'),
                    _buildDetailRow('Methodology', 'AR-ACM0003'),
                    _buildDetailRow('Monitoring Period', '2023-2024'),
                    _buildDetailRow('Issuance Date', date),
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
                    onPressed: () => _shareCertificate(context),
                    icon: const Icon(Icons.share),
                    label: const Text('Share Certificate'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadCertificate(context),
                    icon: const Icon(Icons.download),
                    label: const Text('Download PDF'),
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

  void _downloadCertificate(BuildContext context) {
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

  void _shareCertificate(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Certificate sharing link copied to clipboard'),
      ),
    );
  }
}
