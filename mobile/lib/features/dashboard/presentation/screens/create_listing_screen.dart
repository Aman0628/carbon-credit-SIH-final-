import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key});

  @override
  ConsumerState<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _creditsController = TextEditingController();
  final _locationController = TextEditingController();

  String selectedProjectType = 'Renewable Energy';
  String selectedCertification = 'VCS (Verified Carbon Standard)';
  String selectedVintageYear = '2024';
  bool isActive = true;

  final List<String> projectTypes = [
    'Renewable Energy',
    'Forestry',
    'Reforestation',
    'Energy Efficiency',
    'Waste Management',
    'Agriculture',
    'Transportation',
  ];

  final List<String> certifications = [
    'VCS (Verified Carbon Standard)',
    'Gold Standard',
    'CDM (Clean Development Mechanism)',
    'CAR (Climate Action Reserve)',
    'ACR (American Carbon Registry)',
  ];

  final List<String> vintageYears = [
    '2024',
    '2023',
    '2022',
    '2021',
    '2020',
  ];

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _creditsController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Project'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => _saveDraft(),
            child: const Text(
              'Save Draft',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Information Section
              _buildSectionHeader('Project Information', Icons.info_outline),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _projectNameController,
                        decoration: const InputDecoration(
                          labelText: 'Project Name *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.business),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter project name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedProjectType,
                        decoration: const InputDecoration(
                          labelText: 'Project Type *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: projectTypes.map((type) {
                          return DropdownMenuItem(value: type, child: Text(type));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedProjectType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                          hintText: 'e.g., Maharashtra, India',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter location';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Project Description *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                          hintText: 'Describe your carbon credit project...',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter project description';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Credit Details Section
              _buildSectionHeader('Credit Details', Icons.inventory),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _creditsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Available Credits *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.numbers),
                          suffixText: 'credits',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter number of credits';
                          }
                          if (int.tryParse(value) == null || int.parse(value) <= 0) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price per Credit *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.currency_rupee),
                          suffixText: '₹',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter price per credit';
                          }
                          if (double.tryParse(value) == null || double.parse(value) <= 0) {
                            return 'Please enter a valid price';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedVintageYear,
                        decoration: const InputDecoration(
                          labelText: 'Vintage Year *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        items: vintageYears.map((year) {
                          return DropdownMenuItem(value: year, child: Text(year));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedVintageYear = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Certification Section
              _buildSectionHeader('Certification', Icons.verified),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedCertification,
                        decoration: const InputDecoration(
                          labelText: 'Certification Standard *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.card_membership),
                        ),
                        items: certifications.map((cert) {
                          return DropdownMenuItem(value: cert, child: Text(cert));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCertification = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.info.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: AppColors.info),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Certification documents will be verified before listing goes live',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.info,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Listing Settings Section
              _buildSectionHeader('Listing Settings', Icons.settings),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Active Listing'),
                        subtitle: const Text('Make this listing visible to buyers'),
                        value: isActive,
                        onChanged: (value) {
                          setState(() {
                            isActive = value;
                          });
                        },
                        activeColor: AppColors.success,
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.visibility, color: AppColors.primary),
                        title: const Text('Preview Listing'),
                        subtitle: const Text('See how your listing will appear to buyers'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _previewListing(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Estimated Revenue
              if (_creditsController.text.isNotEmpty && _priceController.text.isNotEmpty)
                Card(
                  color: AppColors.success.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calculate, color: AppColors.success),
                            const SizedBox(width: 12),
                            Text(
                              'Estimated Revenue',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹${_calculateRevenue()}',
                          style: AppTextStyles.heading2.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Total potential revenue from all credits',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _createListing(),
                      icon: const Icon(Icons.publish),
                      label: const Text('Add Project'),
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.heading3.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _calculateRevenue() {
    final credits = int.tryParse(_creditsController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final revenue = credits * price;
    
    if (revenue >= 100000) {
      return '${(revenue / 100000).toStringAsFixed(1)}L';
    } else if (revenue >= 1000) {
      return '${(revenue / 1000).toStringAsFixed(1)}K';
    } else {
      return revenue.toStringAsFixed(0);
    }
  }

  void _previewListing() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields to preview'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Listing Preview'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _projectNameController.text,
                style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('$selectedProjectType • ${_locationController.text}'),
              const SizedBox(height: 12),
              Text(_descriptionController.text),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_creditsController.text} credits'),
                  Text(
                    '₹${_priceController.text}/credit',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Certification: $selectedCertification'),
              Text('Vintage: $selectedVintageYear'),
            ],
          ),
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

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft saved successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _createListing() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add New Project'),
          content: const Text(
            'Are you sure you want to add this project? '
            'It will be reviewed and published within 24 hours.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Listing created successfully! Under review.'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Add Project'),
            ),
          ],
        ),
      );
    }
  }
}
