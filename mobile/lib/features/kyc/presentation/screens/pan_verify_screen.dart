import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/models/user.dart';

class PanVerifyScreen extends ConsumerStatefulWidget {
  const PanVerifyScreen({super.key});

  @override
  ConsumerState<PanVerifyScreen> createState() => _PanVerifyScreenState();
}

class _PanVerifyScreenState extends ConsumerState<PanVerifyScreen> {
  final _panController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _panController.dispose();
    super.dispose();
  }

  void _fillSamplePAN() {
    setState(() {
      _panController.text = 'ABCDE1234F';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sample PAN filled successfully!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  Future<void> _verifyPan() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate PAN verification
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PAN verification successful!'),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate based on user role - sellers need MRV verification
        final authState = ref.read(authProvider);
        final user = authState.user;
        
        if (user?.role == UserRole.seller) {
          // Sellers go to MRV certificate verification
          context.go('/kyc/mrv-certificate');
        } else {
          // Buyers go directly to dashboard
          context.go('/buyer-dashboard');
        }
      }

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PAN Verification'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Verify Your PAN',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your PAN card number to complete KYC',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _panController,
                  keyboardType: TextInputType.text,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'PAN Number',
                    prefixIcon: Icon(Icons.credit_card),
                    hintText: 'e.g., ABCDE1234F (Format: AAAAA9999A)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your PAN number';
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid 10-digit PAN number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyPan,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Verify PAN'),
                ),
                const SizedBox(height: 16),
                
                // Sample Data Button
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _fillSamplePAN,
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text('Fill Sample PAN'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.info,
                    side: BorderSide(color: AppColors.info),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
