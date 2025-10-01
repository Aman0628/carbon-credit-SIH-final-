import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/demo_config.dart';

class CompanyDetailsScreen extends ConsumerStatefulWidget {
  const CompanyDetailsScreen({super.key});

  @override
  ConsumerState<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends ConsumerState<CompanyDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _gstNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _websiteController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedCompanyType;
  bool _isCompanyRegistration = false;

  final List<String> _companyTypes = [
    'Private Limited Company',
    'Public Limited Company',
    'Limited Liability Partnership (LLP)',
    'Partnership Firm',
    'Sole Proprietorship',
    'One Person Company (OPC)',
    'Section 8 Company (NGO)',
    'Cooperative Society',
  ];

  @override
  void dispose() {
    _companyNameController.dispose();
    _registrationNumberController.dispose();
    _gstNumberController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _websiteController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_isCompanyRegistration) {
      // Company registration - validate form first
      if (_formKey.currentState!.validate()) {
        // Skip KYC upload and go directly to waiting page
        context.go('/kyc/waiting');
      }
    } else {
      // Individual registration - go directly to waiting page
      context.go('/kyc/waiting');
    }
  }

  void _handleDemoSkip() {
    context.go('/buyer-dashboard');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo buyer setup completed!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _fillTestData() {
    setState(() {
      _selectedCompanyType = 'Private Limited Company';
      _companyNameController.text = 'Green Tech Solutions Pvt Ltd';
      _registrationNumberController.text = 'U72900KA2020PTC123456';
      _gstNumberController.text = '29ABCDE1234F1Z5';
      _addressController.text = '123 Tech Park, Electronic City';
      _cityController.text = 'Bangalore';
      _stateController.text = 'Karnataka';
      _pincodeController.text = '560100';
      _phoneController.text = '+91 9876543210';
      _emailController.text = 'info@greentech.com';
      _websiteController.text = 'https://www.greentech.com';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test data filled successfully!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                'Company Verification',
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Verify your company details for faster KYC process',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Registration Type Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registration Type',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RadioListTile<bool>(
                        title: const Text('Individual Registration'),
                        subtitle: const Text('Personal account with Aadhaar verification'),
                        value: false,
                        groupValue: _isCompanyRegistration,
                        onChanged: (value) {
                          setState(() {
                            _isCompanyRegistration = value!;
                          });
                        },
                      ),
                      RadioListTile<bool>(
                        title: const Text('Company Registration'),
                        subtitle: const Text('Business account with company verification'),
                        value: true,
                        groupValue: _isCompanyRegistration,
                        onChanged: (value) {
                          setState(() {
                            _isCompanyRegistration = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Individual Registration Info
              if (!_isCompanyRegistration) ...[
                Card(
                  color: AppColors.info.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person,
                          color: AppColors.info,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Individual Registration',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.info,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You will proceed with Aadhaar and PAN card verification for individual account setup.',
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Company Details Form (only shown if company registration is selected)
              if (_isCompanyRegistration) ...[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Company Type
                      DropdownButtonFormField<String>(
                        value: _selectedCompanyType,
                        decoration: const InputDecoration(
                          labelText: 'Company Type *',
                          prefixIcon: Icon(Icons.business),
                          border: OutlineInputBorder(),
                        ),
                        items: _companyTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCompanyType = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select company type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Company Name
                      TextFormField(
                        controller: _companyNameController,
                        decoration: const InputDecoration(
                          labelText: 'Company Name *',
                          prefixIcon: Icon(Icons.business_center),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter company name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Registration Number
                      TextFormField(
                        controller: _registrationNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Company Registration Number *',
                          prefixIcon: Icon(Icons.confirmation_number),
                          border: OutlineInputBorder(),
                          hintText: 'e.g., U12345KA2020PTC123456',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter registration number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // GST Number
                      TextFormField(
                        controller: _gstNumberController,
                        decoration: const InputDecoration(
                          labelText: 'GST Number',
                          prefixIcon: Icon(Icons.receipt),
                          border: OutlineInputBorder(),
                          hintText: 'e.g., 29ABCDE1234F1Z5',
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty && value.length != 15) {
                            return 'GST number should be 15 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Company Address
                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Registered Address *',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter registered address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // City, State, Pincode Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cityController,
                              decoration: const InputDecoration(
                                labelText: 'City *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _stateController,
                              decoration: const InputDecoration(
                                labelText: 'State *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _pincodeController,
                              decoration: const InputDecoration(
                                labelText: 'Pincode *',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                if (value.length != 6) {
                                  return 'Invalid';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Contact Details
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Company Phone *',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Company Email *',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email address';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _websiteController,
                        decoration: const InputDecoration(
                          labelText: 'Company Website',
                          prefixIcon: Icon(Icons.web),
                          border: OutlineInputBorder(),
                          hintText: 'https://www.company.com',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Company Registration Benefits
                Card(
                  color: AppColors.success.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.verified_user,
                          color: AppColors.success,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Company Registration Benefits',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Skip individual Aadhaar verification\n'
                          '• Faster KYC process with company documents\n'
                          '• Higher transaction limits\n'
                          '• Business-specific carbon credit recommendations',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Continue Button
              ElevatedButton(
                onPressed: _handleContinue,
                child: Text(_isCompanyRegistration 
                    ? 'Continue with Company Verification' 
                    : 'Continue with KYC Verification'),
              ),
              const SizedBox(height: 16),

              // Demo Skip Button
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
                      'Skip company verification and go to dashboard',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Test Company Data Button (for development)
                    if (_isCompanyRegistration)
                      OutlinedButton.icon(
                        onPressed: _fillTestData,
                        icon: const Icon(Icons.auto_fix_high),
                        label: const Text('Fill Test Data'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.info,
                          side: BorderSide(color: AppColors.info),
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
}
