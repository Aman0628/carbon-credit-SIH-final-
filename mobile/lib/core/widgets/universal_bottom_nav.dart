import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/portfolio/presentation/screens/portfolio_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';

class UniversalBottomNav extends ConsumerWidget {
  final String currentRoute;
  final bool isBuyer;

  const UniversalBottomNav({
    super.key,
    required this.currentRoute,
    this.isBuyer = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(
                context: context,
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: currentRoute.contains('dashboard'),
                onTap: () => _navigateToHome(context),
              ),
              _buildBottomNavItem(
                context: context,
                icon: Icons.pie_chart_rounded,
                label: 'Portfolio',
                isActive: currentRoute.contains('portfolio'),
                onTap: () => _navigateToPortfolio(context),
              ),
              _buildBottomNavItem(
                context: context,
                icon: Icons.person_rounded,
                label: 'Account',
                isActive: currentRoute.contains('profile') || currentRoute.contains('account'),
                onTap: () => _navigateToProfile(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive 
                  ? const Color(0xFF2E7D32) 
                  : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive 
                    ? const Color(0xFF2E7D32) 
                    : Colors.grey[600],
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    if (isBuyer) {
      context.go('/buyer-dashboard');
    } else {
      context.go('/seller-dashboard');
    }
  }

  void _navigateToPortfolio(BuildContext context) {
    context.go('/portfolio');
  }

  void _navigateToProfile(BuildContext context) {
    context.go('/profile');
  }
}
