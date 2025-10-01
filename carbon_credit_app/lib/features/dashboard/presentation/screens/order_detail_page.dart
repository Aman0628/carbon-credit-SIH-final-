import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;
  final String projectName;
  final String credits;
  final String amount;
  final String status;
  final String date;

  const OrderDetailPage({
    super.key,
    required this.orderId,
    required this.projectName,
    required this.credits,
    required this.amount,
    required this.status,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);
    final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
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
            // Order Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.receipt_long, color: AppColors.primary, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orderId,
                                style: AppTextStyles.heading2,
                              ),
                              Text(
                                'Order placed on $date',
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
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: AppTextStyles.caption.copyWith(
                              color: statusColor,
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

            // Order Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Information',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Order ID', orderId),
                    _buildDetailRow('Project Name', projectName),
                    _buildDetailRow('Credits Ordered', credits),
                    _buildDetailRow('Total Amount', amount),
                    _buildDetailRow('Order Status', status),
                    _buildDetailRow('Order Date', date),
                    _buildDetailRow('Payment Method', 'UPI'),
                    _buildDetailRow('Transaction ID', transactionId),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Order Timeline
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Timeline',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 16),
                    _buildTimelineItem(
                      'Order Placed',
                      date,
                      'Your order has been successfully placed',
                      true,
                    ),
                    _buildTimelineItem(
                      'Payment Confirmed',
                      status != 'Pending' ? date : 'Processing...',
                      'Payment has been verified and confirmed',
                      status != 'Pending',
                    ),
                    _buildTimelineItem(
                      'Credits Allocated',
                      status == 'Completed' ? date : 'Processing...',
                      'Carbon credits have been allocated to your account',
                      status == 'Completed',
                    ),
                    _buildTimelineItem(
                      'Certificate Generated',
                      status == 'Completed' ? date : 'Pending...',
                      'Digital certificate has been generated and is ready for download',
                      status == 'Completed',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Project Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Project Information',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.eco, color: AppColors.primary, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                projectName,
                                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Reforestation Project • Gold Standard Verified',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This project focuses on restoring native forest ecosystems and protecting biodiversity while generating high-quality carbon credits.',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            if (status == 'Pending') ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _contactSupport(context),
                      icon: const Icon(Icons.support_agent),
                      label: const Text('Contact Support'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _cancelOrder(context),
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (status == 'Completed') ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _viewCertificate(context),
                      icon: const Icon(Icons.card_membership),
                      label: const Text('View Certificate'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _downloadInvoice(context),
                      icon: const Icon(Icons.receipt),
                      label: const Text('Download Invoice'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _contactSupport(context),
                  icon: const Icon(Icons.support_agent),
                  label: const Text('Contact Support'),
                ),
              ),
            ],
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

  Widget _buildTimelineItem(String title, String subtitle, String description, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.success : AppColors.textSecondary.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.radio_button_unchecked,
              color: isCompleted ? Colors.white : AppColors.textSecondary,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'processing':
        return AppColors.info;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  void _cancelOrder(BuildContext context) {
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
                context.pop(); // Go back to orders list
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _contactSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connecting you to customer support...')),
    );
  }

  void _viewCertificate(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening certificate...')),
    );
  }

  void _downloadInvoice(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading invoice for $orderId...')),
    );
  }
}
