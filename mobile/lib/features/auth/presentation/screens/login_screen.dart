import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/models/user.dart';
import '../../../../core/config/demo_config.dart'; // DEMO: Import demo config

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      print('Starting login process...');
      await ref.read(authProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (mounted) {
        final authState = ref.read(authProvider);
        print('Login completed - Auth: ${authState.isAuthenticated}, User: ${authState.user?.name}, KYC: ${authState.user?.kycStatus}');
        
        if (authState.isAuthenticated) {
          final user = authState.user!;
          if (user.kycStatus == 'approved') {
            if (user.role == UserRole.buyer) {
              print('Navigating to buyer dashboard');
              context.go('/dashboard/buyer');
            } else {
              print('Navigating to seller dashboard');
              context.go('/dashboard/seller');
            }
          } else {
            print('KYC not approved, navigating to KYC upload');
            context.go('/kyc/upload');
          }
        }
      }
    }
  }

  // DEMO: Quick demo login
  void _handleDemoLogin(UserRole role) async {
    final email = role == UserRole.buyer 
        ? DemoConfig.DEMO_BUYER_EMAIL 
        : DemoConfig.DEMO_SELLER_EMAIL;
    
    await ref.read(authProvider.notifier).login(
      email,
      DemoConfig.DEMO_PASSWORD,
    );
    
    if (mounted) {
      final authState = ref.read(authProvider);
      if (authState.isAuthenticated) {
        if (role == UserRole.buyer) {
          context.go('/buyer-dashboard');
        } else {
          context.go('/seller-dashboard');
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Demo ${role.name} login successful!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Welcome Back',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Login to your carbon credit account',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Error Message
                if (authState.error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      authState.error!,
                      style: const TextStyle(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (authState.error != null) const SizedBox(height: 16),
                
                // Login Button
                ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleLogin,
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Login'),
                ),
                const SizedBox(height: 16),
                
                // DEMO: Quick Demo Login Buttons
                if (DemoConfig.ENABLE_DEMO_LOGIN)
                  Column(
                    children: [
                      Text(
                        'Quick Demo Access',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: authState.isLoading ? null : () => _handleDemoLogin(UserRole.buyer),
                              icon: const Icon(Icons.shopping_cart, size: 16),
                              label: const Text('Demo Buyer'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: BorderSide(color: AppColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: authState.isLoading ? null : () => _handleDemoLogin(UserRole.seller),
                              icon: const Icon(Icons.sell, size: 16),
                              label: const Text('Demo Seller'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.success,
                                side: BorderSide(color: AppColors.success),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Instant access with pre-configured demo accounts',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                
                // Register Link
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: const Text('Don\'t have an account? Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
