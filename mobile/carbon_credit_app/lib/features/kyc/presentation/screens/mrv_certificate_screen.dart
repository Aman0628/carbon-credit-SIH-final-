import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/models/user.dart';

class MRVCertificateScreen extends ConsumerStatefulWidget {
  const MRVCertificateScreen({super.key});

  @override
  ConsumerState<MRVCertificateScreen> createState() => _MRVCertificateScreenState();
}

class _MRVCertificateScreenState extends ConsumerState<MRVCertificateScreen> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _certificateNumberController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _issuingAuthorityController = TextEditingController();
  
  XFile? _certificateDocument;
  String? _selectedCertificateType;
  bool _isUploading = false;

  final List<String> _certificateTypes = [
    'VCS (Verified Carbon Standard)',
    'Gold Standard',
    'CDM (Clean Development Mechanism)',
    'CAR (Climate Action Reserve)',
    'ACR (American Carbon Registry)',
    'Plan Vivo',
    'Other International Standard',
  ];

  @override
  void dispose() {
    _certificateNumberController.dispose();
    _projectNameController.dispose();
    _issuingAuthorityController.dispose();
    super.dispose();
  }

  void _fillSampleData() {
    setState(() {
      _selectedCertificateType = 'VCS (Verified Carbon Standard)';
      _certificateNumberController.text = 'VCS-2024-001234';
      _projectNameController.text = 'Solar Energy Project - Maharashtra';
      _issuingAuthorityController.text = 'Verra (VCS Program)';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sample data filled successfully!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  Future<void> _pickCertificateDocument() async {
    final XFile? document = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    
    if (document != null) {
      setState(() {
        _certificateDocument = document;
      });
    }
  }

  Future<void> _verifyCertificate() async {
    if (_formKey.currentState!.validate() && _certificateDocument != null) {
      setState(() => _isUploading = true);

      try {
        // Simulate MRV certificate verification process
        await Future.delayed(const Duration(seconds: 3));

        if (mounted) {
          // Navigate to dashboard immediately after submission
          final authState = ref.read(authProvider);
          final user = authState.user!;
          
          if (user.role == UserRole.seller) {
            context.go('/seller-dashboard');
            // Show verification notification on dashboard
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Verification under process - You will be notified once verified'),
                    backgroundColor: AppColors.warning,
                    duration: Duration(seconds: 5),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(16),
                  ),
                );
              }
            });
          } else {
            context.go('/buyer-dashboard');
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Verification failed: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        setState(() => _isUploading = false);
      }
    } else if (_certificateDocument == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload your MRV certificate document'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MRV Certificate Verification'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  'Verify Your MRV Certificate',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'As a carbon credit generator, please provide your MRV (Monitoring, Reporting, and Verification) certificate to verify your project authenticity.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Certificate Type Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCertificateType,
                  decoration: const InputDecoration(
                    labelText: 'Certificate Standard',
                    prefixIcon: Icon(Icons.verified),
                    border: OutlineInputBorder(),
                  ),
                  items: _certificateTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCertificateType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select certificate standard';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Certificate Number
                TextFormField(
                  controller: _certificateNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Certificate Number',
                    prefixIcon: Icon(Icons.numbers),
                    border: OutlineInputBorder(),
                    hintText: 'e.g., VCS-2024-001234, GS-2024-5678',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter certificate number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Project Name
                TextFormField(
                  controller: _projectNameController,
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                    prefixIcon: Icon(Icons.eco),
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Solar Energy Project - Maharashtra',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter project name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Issuing Authority
                TextFormField(
                  controller: _issuingAuthorityController,
                  decoration: const InputDecoration(
                    labelText: 'Issuing Authority',
                    prefixIcon: Icon(Icons.business),
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Verra (VCS Program), Gold Standard Foundation',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter issuing authority';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Certificate Document Upload
                _buildDocumentUploadCard(),
                const SizedBox(height: 24),

                // Information Card
                Card(
                  color: AppColors.info.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.info,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Why MRV Certificate?',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'MRV certificates ensure that your carbon credit projects meet international standards and are genuine. This verification protects buyers and maintains market integrity.',
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Verify Button
                ElevatedButton(
                  onPressed: _isUploading ? null : _verifyCertificate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isUploading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('Verifying Certificate...'),
                          ],
                        )
                      : const Text('Submit for Verification'),
                ),
                const SizedBox(height: 16),

                // Sample Data Button
                OutlinedButton.icon(
                  onPressed: _fillSampleData,
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text('Fill Sample Data'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.info,
                    side: BorderSide(color: AppColors.info),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Skip for now (temporary)
                TextButton(
                  onPressed: () {
                    final authState = ref.read(authProvider);
                    final user = authState.user!;
                    
                    if (user.role == UserRole.seller) {
                      context.go('/seller-dashboard');
                    } else {
                      context.go('/buyer-dashboard');
                    }
                  },
                  child: Text(
                    'Skip for now (Demo Mode)',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentUploadCard() {
    return GestureDetector(
      onTap: _pickCertificateDocument,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: _certificateDocument != null ? AppColors.success : AppColors.divider,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: _certificateDocument != null 
              ? AppColors.success.withOpacity(0.1) 
              : Colors.grey.withOpacity(0.05),
        ),
        child: _certificateDocument != null
            ? Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.success.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 32,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Certificate Document',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Document uploaded successfully',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.upload_file,
                      color: AppColors.success,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.upload_file,
                    size: 32,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload Certificate Document',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to upload PDF or image of your MRV certificate',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
