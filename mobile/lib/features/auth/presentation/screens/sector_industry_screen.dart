import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/demo_config.dart'; // DEMO: Import demo config

class SectorIndustryScreen extends ConsumerStatefulWidget {
  const SectorIndustryScreen({super.key});

  @override
  ConsumerState<SectorIndustryScreen> createState() => _SectorIndustryScreenState();
}

class _SectorIndustryScreenState extends ConsumerState<SectorIndustryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedSector;
  String? _selectedIndustry;

  final List<String> _sectors = [
    'Manufacturing',
    'Services',
    'Agriculture',
    'Energy & Utilities',
    'Transportation',
    'Construction',
    'Mining',
    'Technology',
    'Healthcare',
    'Education',
    'Finance & Banking',
    'Retail & Commerce',
    'Tourism & Hospitality',
    'Government',
    'Other',
  ];

  final Map<String, List<String>> _industriesBySector = {
    'Manufacturing': [
      'Steel & Iron',
      'Cement',
      'Chemicals & Petrochemicals',
      'Textiles',
      'Automotive',
      'Electronics',
      'Food & Beverages',
      'Pharmaceuticals',
      'Paper & Pulp',
      'Plastics',
    ],
    'Services': [
      'IT Services',
      'Consulting',
      'Financial Services',
      'Legal Services',
      'Marketing & Advertising',
      'Real Estate',
      'Logistics & Supply Chain',
      'Professional Services',
    ],
    'Agriculture': [
      'Crop Production',
      'Livestock',
      'Dairy',
      'Fisheries',
      'Forestry',
      'Agro-processing',
      'Organic Farming',
    ],
    'Energy & Utilities': [
      'Power Generation',
      'Oil & Gas',
      'Renewable Energy',
      'Water Supply',
      'Waste Management',
      'Nuclear Energy',
    ],
    'Transportation': [
      'Airlines',
      'Railways',
      'Shipping',
      'Trucking',
      'Public Transport',
      'Logistics',
    ],
    'Construction': [
      'Residential Construction',
      'Commercial Construction',
      'Infrastructure',
      'Real Estate Development',
    ],
    'Mining': [
      'Coal Mining',
      'Metal Mining',
      'Oil & Gas Extraction',
      'Quarrying',
    ],
    'Technology': [
      'Software Development',
      'Hardware Manufacturing',
      'Telecommunications',
      'Data Centers',
      'AI & Machine Learning',
    ],
    'Healthcare': [
      'Hospitals',
      'Pharmaceuticals',
      'Medical Devices',
      'Healthcare Services',
    ],
    'Education': [
      'Schools',
      'Universities',
      'Training Institutes',
      'Online Education',
    ],
    'Finance & Banking': [
      'Commercial Banking',
      'Investment Banking',
      'Insurance',
      'Asset Management',
    ],
    'Retail & Commerce': [
      'E-commerce',
      'Supermarkets',
      'Fashion Retail',
      'Electronics Retail',
    ],
    'Tourism & Hospitality': [
      'Hotels',
      'Restaurants',
      'Travel Agencies',
      'Event Management',
    ],
    'Government': [
      'Public Administration',
      'Defense',
      'Public Utilities',
      'Regulatory Bodies',
    ],
    'Other': [
      'Non-profit Organizations',
      'Research Institutions',
      'Media & Entertainment',
      'Sports & Recreation',
    ],
  };

  List<String> get _availableIndustries {
    if (_selectedSector == null) return [];
    return _industriesBySector[_selectedSector!] ?? [];
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      // Navigate to company details screen for verification
      context.go('/company-details');
    }
  }

  // DEMO: Skip sector-industry selection
  void _handleDemoSkip() {
    // Skip directly to buyer dashboard for demo
    context.go('/buyer-dashboard');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo buyer setup completed!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sector & Industry'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Select Your Sector & Industry',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Help us understand your business better',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Sector Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedSector,
                  decoration: const InputDecoration(
                    labelText: 'Select Sector',
                    prefixIcon: Icon(Icons.business),
                    border: OutlineInputBorder(),
                  ),
                  items: _sectors.map((sector) {
                    return DropdownMenuItem(
                      value: sector,
                      child: Text(sector),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSector = value;
                      _selectedIndustry = null; // Reset industry when sector changes
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a sector';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Industry Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedIndustry,
                  decoration: const InputDecoration(
                    labelText: 'Select Industry',
                    prefixIcon: Icon(Icons.factory),
                    border: OutlineInputBorder(),
                  ),
                  items: _availableIndustries.map((industry) {
                    return DropdownMenuItem(
                      value: industry,
                      child: Text(industry),
                    );
                  }).toList(),
                  onChanged: _selectedSector == null
                      ? null
                      : (value) {
                          setState(() {
                            _selectedIndustry = value;
                          });
                        },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an industry';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Continue Button
                ElevatedButton(
                  onPressed: _handleContinue,
                  child: const Text('Continue to Company Details'),
                ),
                const SizedBox(height: 16),
                
                // DEMO: Skip for Demo Button
                if (DemoConfig.ENABLE_REGISTRATION_SKIP)
                  Column(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _handleDemoSkip,
                        icon: const Icon(Icons.fast_forward),
                        label: const Text('Skip for Demo'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.warning,
                          side: BorderSide(color: AppColors.warning),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Skip sector selection and go to dashboard',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

                // Info Card
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
                          'Why do we need this information?',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This helps us provide you with relevant carbon credit recommendations and compliance requirements specific to your industry.',
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
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
}
