import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/config/demo_config.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/models/user.dart';

class KYCUploadScreen extends ConsumerStatefulWidget {
  const KYCUploadScreen({super.key});

  @override
  ConsumerState<KYCUploadScreen> createState() => _KYCUploadScreenState();
}

class _KYCUploadScreenState extends ConsumerState<KYCUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _aadhaarFront;
  XFile? _aadhaarBack;
  bool _isUploading = false;
  String _registrationType = 'individual';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uri = GoRouterState.of(context).uri;
    _registrationType = uri.queryParameters['type'] ?? 'individual';
  }

  Future<void> _pickImage(String documentType) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        switch (documentType) {
          case 'aadhaar_front':
            _aadhaarFront = image;
            break;
          case 'aadhaar_back':
            _aadhaarBack = image;
            break;
        }
      });
    }
  }

  bool get _isIndividualRegistration => _registrationType == 'individual';

  Future<void> _uploadDocuments() async {
    if (_isIndividualRegistration) {
      if (_aadhaarFront == null || _aadhaarBack == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please capture both sides of Aadhaar card'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    setState(() => _isUploading = true);

    try {
      final apiService = ApiService();

      if (_isIndividualRegistration) {
        await apiService.uploadKYCDocument('aadhaar_front', _aadhaarFront!.path);
        await apiService.uploadKYCDocument('aadhaar_back', _aadhaarBack!.path);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isIndividualRegistration
                  ? 'Aadhaar documents uploaded successfully!'
                  : 'Proceeding to next step.',
            ),
            backgroundColor: AppColors.success,
          ),
        );

        if (_isIndividualRegistration) {
          context.go('/kyc/aadhaar-verify');
        } else {
          context.go('/kyc/pan-verify');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _handleDemoSkip() {
    final authState = ref.read(authProvider);
    final user = authState.user;

    if (user?.role == UserRole.seller) {
      context.go('/seller-dashboard');
    } else {
      context.go('/buyer-dashboard');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo KYC completed - Welcome to the dashboard!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KYC Verification'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isIndividualRegistration
                    ? 'Upload KYC Documents'
                    : 'KYC Verification',
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _isIndividualRegistration
                    ? 'Please capture clear photos of your Aadhaar card'
                    : 'You will proceed to the next step for verification.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              if (_isIndividualRegistration) ...[
                _buildUploadCard(
                  title: 'Aadhaar Front Side',
                  subtitle: 'Capture the front side with your photo',
                  image: _aadhaarFront,
                  onTap: () => _pickImage('aadhaar_front'),
                ),
                const SizedBox(height: 16),
                _buildUploadCard(
                  title: 'Aadhaar Back Side',
                  subtitle: 'Capture the back side with address',
                  image: _aadhaarBack,
                  onTap: () => _pickImage('aadhaar_back'),
                ),
              ],

              const Spacer(),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.security, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your data is secure',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.info,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'All documents are encrypted and stored securely. We comply with Indian data protection laws.',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isUploading ? null : _uploadDocuments,
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
                          Text('Uploading...'),
                        ],
                      )
                    : const Text('Continue'),
              ),
              const SizedBox(height: 16),

              if (DemoConfig.ENABLE_KYC_SKIP)
                Column(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _isUploading ? null : _handleDemoSkip,
                      icon: const Icon(Icons.fast_forward),
                      label: const Text('Skip KYC for Demo'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.warning,
                        side: BorderSide(color: AppColors.warning),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Skip document upload and go to dashboard',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard({
    required String title,
    required String subtitle,
    required XFile? image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: image != null ? AppColors.success : AppColors.divider,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: image != null
              ? AppColors.success.withOpacity(0.1)
              : Colors.grey.withOpacity(0.05),
        ),
        child: image != null
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
                          title,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Captured successfully',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.camera_alt, color: AppColors.success),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt,
                    size: 32,
                    color: AppColors.textSecondary,
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
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
