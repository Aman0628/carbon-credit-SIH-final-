import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Logo and Title
              Container(
                height: 120,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/balancing our carbon footfrints.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Trade verified carbon credits with confidence',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),
              
              // Feature Cards
              _buildFeatureCard(
                icon: Icons.verified,
                title: 'Verified Credits',
                description: 'All credits are certified by recognized standards',
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                icon: Icons.security,
                title: 'Secure Trading',
                description: 'Aadhaar-based KYC ensures trusted transactions',
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                icon: Icons.trending_up,
                title: 'Market Insights',
                description: 'Real-time pricing and market analytics',
              ),
              
              const Spacer(),
              
              // Get Started Button
              ElevatedButton(
                onPressed: () => context.go('/register'),
                child: const Text('Get Started'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
