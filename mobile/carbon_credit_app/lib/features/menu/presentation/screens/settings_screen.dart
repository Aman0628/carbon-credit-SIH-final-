import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  bool _marketingEmails = false;
  bool _biometricAuth = false;
  bool _twoFactorAuth = true;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'INR (₹)';
  String _selectedTheme = 'System';

  final List<String> _languages = ['English', 'Hindi', 'Bengali', 'Tamil', 'Telugu'];
  final List<String> _currencies = ['INR (₹)', 'USD (\$)', 'EUR (€)', 'GBP (£)'];
  final List<String> _themes = ['Light', 'Dark', 'System'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings
            _buildSectionHeader('Account Settings'),
            _buildSettingsCard([
              _buildListTile(
                icon: Icons.person,
                title: 'Profile Information',
                subtitle: 'Update your personal details',
                onTap: () => context.push('/account'),
              ),
              _buildListTile(
                icon: Icons.security,
                title: 'Privacy & Security',
                subtitle: 'Manage your privacy settings',
                onTap: () => _showPrivacySettings(),
              ),
              _buildListTile(
                icon: Icons.verified_user,
                title: 'KYC Verification',
                subtitle: 'Complete your verification',
                onTap: () => _showKYCStatus(),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Verified',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 24),

            // Notifications
            _buildSectionHeader('Notifications'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.notifications,
                title: 'Enable Notifications',
                subtitle: 'Receive app notifications',
                value: _notificationsEnabled,
                onChanged: (value) => setState(() => _notificationsEnabled = value),
              ),
              _buildSwitchTile(
                icon: Icons.email,
                title: 'Email Notifications',
                subtitle: 'Receive notifications via email',
                value: _emailNotifications,
                onChanged: (value) => setState(() => _emailNotifications = value),
                enabled: _notificationsEnabled,
              ),
              _buildSwitchTile(
                icon: Icons.push_pin,
                title: 'Push Notifications',
                subtitle: 'Receive push notifications',
                value: _pushNotifications,
                onChanged: (value) => setState(() => _pushNotifications = value),
                enabled: _notificationsEnabled,
              ),
              _buildSwitchTile(
                icon: Icons.sms,
                title: 'SMS Notifications',
                subtitle: 'Receive notifications via SMS',
                value: _smsNotifications,
                onChanged: (value) => setState(() => _smsNotifications = value),
                enabled: _notificationsEnabled,
              ),
              _buildSwitchTile(
                icon: Icons.campaign,
                title: 'Marketing Emails',
                subtitle: 'Receive promotional emails',
                value: _marketingEmails,
                onChanged: (value) => setState(() => _marketingEmails = value),
              ),
            ]),
            const SizedBox(height: 24),

            // Security
            _buildSectionHeader('Security'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.fingerprint,
                title: 'Biometric Authentication',
                subtitle: 'Use fingerprint or face unlock',
                value: _biometricAuth,
                onChanged: (value) => setState(() => _biometricAuth = value),
              ),
              _buildSwitchTile(
                icon: Icons.security,
                title: 'Two-Factor Authentication',
                subtitle: 'Add extra security to your account',
                value: _twoFactorAuth,
                onChanged: (value) => setState(() => _twoFactorAuth = value),
              ),
              _buildListTile(
                icon: Icons.lock,
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () => _showChangePasswordDialog(),
              ),
            ]),
            const SizedBox(height: 24),

            // Preferences
            _buildSectionHeader('Preferences'),
            _buildSettingsCard([
              _buildDropdownTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'Choose your preferred language',
                value: _selectedLanguage,
                items: _languages,
                onChanged: (value) => setState(() => _selectedLanguage = value!),
              ),
              _buildDropdownTile(
                icon: Icons.currency_rupee,
                title: 'Currency',
                subtitle: 'Select your preferred currency',
                value: _selectedCurrency,
                items: _currencies,
                onChanged: (value) => setState(() => _selectedCurrency = value!),
              ),
              _buildDropdownTile(
                icon: Icons.palette,
                title: 'Theme',
                subtitle: 'Choose app appearance',
                value: _selectedTheme,
                items: _themes,
                onChanged: (value) => setState(() => _selectedTheme = value!),
              ),
            ]),
            const SizedBox(height: 24),

            // Support & Legal
            _buildSectionHeader('Support & Legal'),
            _buildSettingsCard([
              _buildListTile(
                icon: Icons.help,
                title: 'Help & Support',
                subtitle: 'Get help and contact support',
                onTap: () => context.push('/contact-us'),
              ),
              _buildListTile(
                icon: Icons.description,
                title: 'Terms of Service',
                subtitle: 'Read our terms and conditions',
                onTap: () => _showTermsOfService(),
              ),
              _buildListTile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                subtitle: 'Learn about our privacy practices',
                onTap: () => _showPrivacyPolicy(),
              ),
              _buildListTile(
                icon: Icons.info,
                title: 'About',
                subtitle: 'App version and information',
                onTap: () => _showAboutDialog(),
              ),
            ]),
            const SizedBox(height: 24),

            // Data Management
            _buildSectionHeader('Data Management'),
            _buildSettingsCard([
              _buildListTile(
                icon: Icons.download,
                title: 'Export Data',
                subtitle: 'Download your account data',
                onTap: () => _exportData(),
              ),
              _buildListTile(
                icon: Icons.delete_forever,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                onTap: () => _showDeleteAccountDialog(),
                textColor: AppColors.error,
              ),
            ]),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: AppTextStyles.heading3.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Card(
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: enabled ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: enabled ? null : AppColors.textSecondary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodyMedium.copyWith(
          color: enabled ? AppColors.textSecondary : AppColors.textSecondary.withOpacity(0.5),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        underline: const SizedBox(),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    );
  }

  void _showPrivacySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy settings coming soon!')),
    );
  }

  void _showKYCStatus() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('KYC Verification Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_user, color: AppColors.success, size: 64),
            const SizedBox(height: 16),
            Text(
              'Your KYC verification is complete!',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Verified on: 15 Dec 2023',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully!')),
              );
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terms of Service coming soon!')),
    );
  }

  void _showPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy Policy coming soon!')),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Carbon Credit App',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(Icons.eco, color: AppColors.primary, size: 48),
      children: [
        const Text('A comprehensive platform for carbon credit trading and environmental impact tracking.'),
      ],
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preparing data export... You will receive an email shortly.'),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: TextStyle(color: AppColors.error),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion request submitted. You will receive a confirmation email.'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
