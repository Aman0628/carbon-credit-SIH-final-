import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class ComplianceCheckScreen extends ConsumerStatefulWidget {
  const ComplianceCheckScreen({super.key});

  @override
  ConsumerState<ComplianceCheckScreen> createState() => _ComplianceCheckScreenState();
}

class _ComplianceCheckScreenState extends ConsumerState<ComplianceCheckScreen> {
  String selectedProject = 'Solar Farm Maharashtra';
  
  final List<String> projects = [
    'Solar Farm Maharashtra',
    'Wind Energy Gujarat',
    'Reforestation Himachal',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compliance Check'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Selection
            Text(
              'Select Project',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<String>(
                  value: selectedProject,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Project Name',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: projects.map((project) {
                    return DropdownMenuItem(value: project, child: Text(project));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProject = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Compliance Status Overview
            Text(
              'Compliance Status',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.success.withOpacity(0.1),
                      child: Icon(
                        Icons.verified_user,
                        color: AppColors.success,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fully Compliant',
                            style: AppTextStyles.heading3.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'All requirements met',
                            style: AppTextStyles.bodyMedium.copyWith(
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
                        '98%',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Compliance Categories
            Text(
              'Compliance Categories',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  _buildComplianceItem(
                    'Environmental Standards',
                    'VCS Verified Carbon Standard',
                    true,
                    Icons.eco,
                    'Valid until Dec 2025',
                  ),
                  const Divider(height: 1),
                  _buildComplianceItem(
                    'Legal Documentation',
                    'All permits and licenses',
                    true,
                    Icons.gavel,
                    'Updated 2 months ago',
                  ),
                  const Divider(height: 1),
                  _buildComplianceItem(
                    'Financial Auditing',
                    'Third-party audit completed',
                    true,
                    Icons.account_balance,
                    'Audit date: Jan 2024',
                  ),
                  const Divider(height: 1),
                  _buildComplianceItem(
                    'Monitoring & Reporting',
                    'MRV system operational',
                    false,
                    Icons.monitor,
                    'Update required',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Certification Details
            Text(
              'Active Certifications',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  _buildCertificationItem(
                    'VCS (Verified Carbon Standard)',
                    'Certificate ID: VCS-2024-001',
                    'Valid until: Dec 31, 2025',
                    AppColors.success,
                  ),
                  const Divider(height: 1),
                  _buildCertificationItem(
                    'Gold Standard',
                    'Certificate ID: GS-2024-002',
                    'Valid until: Jun 30, 2025',
                    AppColors.success,
                  ),
                  const Divider(height: 1),
                  _buildCertificationItem(
                    'ISO 14064-2',
                    'Certificate ID: ISO-2024-003',
                    'Renewal due: Mar 15, 2025',
                    AppColors.warning,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Compliance Activities
            Text(
              'Recent Activities',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  _buildActivityItem(
                    'Annual compliance report submitted',
                    '2 days ago',
                    Icons.description,
                    AppColors.success,
                  ),
                  const Divider(height: 1),
                  _buildActivityItem(
                    'Third-party verification completed',
                    '1 week ago',
                    Icons.verified,
                    AppColors.info,
                  ),
                  const Divider(height: 1),
                  _buildActivityItem(
                    'Environmental impact assessment updated',
                    '2 weeks ago',
                    Icons.assessment,
                    AppColors.primary,
                  ),
                  const Divider(height: 1),
                  _buildActivityItem(
                    'MRV system maintenance required',
                    '1 month ago',
                    Icons.warning,
                    AppColors.warning,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _generateComplianceReport(),
                    icon: const Icon(Icons.file_download),
                    label: const Text('Generate Report'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _scheduleAudit(),
                    icon: const Icon(Icons.schedule),
                    label: const Text('Schedule Audit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceItem(String title, String subtitle, bool isCompliant, IconData icon, String details) {
    Color statusColor = isCompliant ? AppColors.success : AppColors.warning;
    IconData statusIcon = isCompliant ? Icons.check_circle : Icons.warning;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withOpacity(0.1),
        child: Icon(icon, color: statusColor),
      ),
      title: Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle, style: AppTextStyles.bodyMedium),
          Text(details, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
        ],
      ),
      trailing: Icon(statusIcon, color: statusColor),
      onTap: () => _showComplianceDetails(title),
    );
  }

  Widget _buildCertificationItem(String title, String certificateId, String validity, Color statusColor) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withOpacity(0.1),
        child: Icon(Icons.card_membership, color: statusColor),
      ),
      title: Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(certificateId, style: AppTextStyles.caption),
          Text(validity, style: AppTextStyles.caption.copyWith(color: statusColor)),
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
      onTap: () => _viewCertificate(title),
    );
  }

  Widget _buildActivityItem(String activity, String time, IconData icon, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(activity, style: AppTextStyles.bodyMedium),
      subtitle: Text(time, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
    );
  }

  void _showComplianceDetails(String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category),
        content: Text(
          'Detailed compliance information for $category:\n\n'
          '• Current status and requirements\n'
          '• Documentation checklist\n'
          '• Renewal dates and procedures\n'
          '• Contact information for authorities',
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

  void _viewCertificate(String certificate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(certificate),
        content: Text(
          'Certificate details:\n\n'
          '• Issuing authority information\n'
          '• Scope and coverage\n'
          '• Validity period\n'
          '• Renewal requirements\n'
          '• Download certificate PDF',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Certificate downloaded!')),
              );
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  void _generateComplianceReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Compliance Report'),
        content: const Text(
          'Generate a comprehensive compliance report including:\n\n'
          '• Current compliance status\n'
          '• All active certifications\n'
          '• Recent audit results\n'
          '• Upcoming renewal dates\n'
          '• Recommended actions',
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
                const SnackBar(content: Text('Compliance report generated and downloaded!')),
              );
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _scheduleAudit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schedule Compliance Audit'),
        content: const Text(
          'Schedule a third-party compliance audit:\n\n'
          '• Choose audit type and scope\n'
          '• Select preferred audit firm\n'
          '• Set audit dates\n'
          '• Prepare required documentation',
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
                const SnackBar(content: Text('Audit scheduling request submitted!')),
              );
            },
            child: const Text('Schedule'),
          ),
        ],
      ),
    );
  }
}
