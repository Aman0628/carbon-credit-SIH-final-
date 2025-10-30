import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/demo_config.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/models/user.dart';

class KYCWaitingScreen extends ConsumerStatefulWidget {
  const KYCWaitingScreen({super.key});

  @override
  ConsumerState<KYCWaitingScreen> createState() => _KYCWaitingScreenState();
}

class _KYCWaitingScreenState extends ConsumerState<KYCWaitingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
        content: Text('Demo verification completed - Welcome to the dashboard!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification in Progress'),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated verification icon
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.verified_user,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              
              // Title
              Text(
                'Verification in Progress',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Subtitle
              Text(
                'Your documents are being verified',
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              Text(
                'This usually takes 2-3 business days',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Progress steps
              _buildProgressStep(
                icon: Icons.upload_file,
                title: 'Documents Uploaded',
                subtitle: 'Your documents have been received',
                isCompleted: true,
              ),
              const SizedBox(height: 16),
              
              _buildProgressStep(
                icon: Icons.search,
                title: 'Under Review',
                subtitle: 'Our team is verifying your information',
                isCompleted: false,
                isActive: true,
              ),
              const SizedBox(height: 16),
              
              _buildProgressStep(
                icon: Icons.check_circle,
                title: 'Verification Complete',
                subtitle: 'You will receive email confirmation',
                isCompleted: false,
              ),
              const SizedBox(height: 48),
              
              // Info card
              Card(
                color: AppColors.info.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.info,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'What happens next?',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '• You will receive an email notification once verification is complete\n'
                        '• If additional documents are needed, we will contact you\n'
                        '• Once approved, you can start trading carbon credits',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              
              // Demo skip button
              if (DemoConfig.ENABLE_KYC_SKIP)
                OutlinedButton.icon(
                  onPressed: _handleDemoSkip,
                  icon: const Icon(Icons.fast_forward),
                  label: const Text('Skip Verification for Demo'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warning,
                    side: BorderSide(color: AppColors.warning),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCompleted,
    bool isActive = false,
  }) {
    Color iconColor;
    Color backgroundColor;
    
    if (isCompleted) {
      iconColor = AppColors.success;
      backgroundColor = AppColors.success.withOpacity(0.1);
    } else if (isActive) {
      iconColor = AppColors.primary;
      backgroundColor = AppColors.primary.withOpacity(0.1);
    } else {
      iconColor = AppColors.textSecondary;
      backgroundColor = AppColors.textSecondary.withOpacity(0.1);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check_circle : icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isCompleted || isActive ? null : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isCompleted || isActive 
                        ? AppColors.textSecondary 
                        : AppColors.textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
