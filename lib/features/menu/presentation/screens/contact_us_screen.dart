import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class ContactUsScreen extends ConsumerStatefulWidget {
  const ContactUsScreen({super.key});

  @override
  ConsumerState<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends ConsumerState<ContactUsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = 'General Inquiry';

  final List<String> _categories = [
    'General Inquiry',
    'Technical Support',
    'Account Issues',
    'Payment Problems',
    'Order Support',
    'KYC Verification',
    'Feedback',
    'Bug Report',
  ];

  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I purchase carbon credits?',
      'answer': 'You can purchase carbon credits by browsing our marketplace, selecting the credits you want, and completing the checkout process. All purchases are verified and certificates are issued upon completion.',
    },
    {
      'question': 'What payment methods are accepted?',
      'answer': 'We accept credit/debit cards, UPI, net banking, and wallet payments. You can manage your payment methods in the Payment Options section.',
    },
    {
      'question': 'How long does KYC verification take?',
      'answer': 'KYC verification typically takes 1-3 business days. You will receive an email notification once your verification is complete.',
    },
    {
      'question': 'Can I cancel my order?',
      'answer': 'Orders can be cancelled within 24 hours of placement if they haven\'t been processed. You can cancel orders from the Orders section in your account.',
    },
    {
      'question': 'How do I download my certificates?',
      'answer': 'Certificates can be downloaded from the My Certificates section. Click on any completed purchase to view and download your certificate.',
    },
    {
      'question': 'What is the difference between credits and certificates?',
      'answer': 'Carbon credits are the tradeable units representing emission reductions. Certificates are the official documents proving your ownership and retirement of credits.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Contact', icon: Icon(Icons.contact_support)),
            Tab(text: 'FAQ', icon: Icon(Icons.help)),
            Tab(text: 'Info', icon: Icon(Icons.info)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildContactTab(),
          _buildFAQTab(),
          _buildInfoTab(),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Contact Options
          Text(
            'Quick Contact',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickContactCard(
                  'Call Us',
                  '+91 1800-123-4567',
                  Icons.phone,
                  AppColors.success,
                  () => _makePhoneCall(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickContactCard(
                  'Email Us',
                  'support@ecoex.com',
                  Icons.email,
                  AppColors.primary,
                  () => _sendEmail(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickContactCard(
                  'Live Chat',
                  'Available 24/7',
                  Icons.chat,
                  AppColors.info,
                  () => _startLiveChat(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickContactCard(
                  'WhatsApp',
                  '+91 9876543210',
                  Icons.message,
                  AppColors.success,
                  () => _openWhatsApp(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Contact Form
          Text(
            'Send us a Message',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        prefixIcon: const Icon(Icons.category),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Subject Field
                    TextFormField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        prefixIcon: const Icon(Icons.subject),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a subject';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Message Field
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        labelText: 'Message',
                        prefixIcon: const Icon(Icons.message),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your message';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Send Message'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _faqs.length,
            itemBuilder: (context, index) {
              final faq = _faqs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  title: Text(
                    faq['question'],
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        faq['answer'],
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Card(
            color: AppColors.primary.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    Icons.help_outline,
                    color: AppColors.primary,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Still have questions?',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Contact our support team for personalized assistance',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _tabController.animateTo(0),
                    child: const Text('Contact Support'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Info
          Text(
            'Company Information',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.business, 'Company', 'EcoEx Carbon Trading Platform'),
                  _buildInfoRow(Icons.location_on, 'Address', 'Green Tower, Sector 18, Gurugram, Haryana 122015'),
                  _buildInfoRow(Icons.phone, 'Phone', '+91 1800-123-4567'),
                  _buildInfoRow(Icons.email, 'Email', 'support@ecoex.com'),
                  _buildInfoRow(Icons.web, 'Website', 'www.ecoex.com'),
                  _buildInfoRow(Icons.access_time, 'Business Hours', 'Mon-Fri: 9:00 AM - 6:00 PM IST'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Office Locations
          Text(
            'Office Locations',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          _buildOfficeCard(
            'Head Office - Gurugram',
            'Green Tower, Sector 18\nGurugram, Haryana 122015',
            '+91 1800-123-4567',
            'headoffice@ecoex.com',
          ),
          const SizedBox(height: 12),
          _buildOfficeCard(
            'Regional Office - Mumbai',
            'Eco Plaza, Bandra Kurla Complex\nMumbai, Maharashtra 400051',
            '+91 1800-123-4568',
            'mumbai@ecoex.com',
          ),
          const SizedBox(height: 12),
          _buildOfficeCard(
            'Regional Office - Bangalore',
            'Tech Park, Electronic City\nBangalore, Karnataka 560100',
            '+91 1800-123-4569',
            'bangalore@ecoex.com',
          ),
          const SizedBox(height: 24),

          // Social Media
          Text(
            'Follow Us',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSocialButton('LinkedIn', Icons.business, AppColors.info),
                      _buildSocialButton('Twitter', Icons.alternate_email, AppColors.primary),
                      _buildSocialButton('Facebook', Icons.facebook, AppColors.info),
                      _buildSocialButton('Instagram', Icons.camera_alt, AppColors.warning),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Stay updated with the latest news and updates from EcoEx',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickContactCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficeCard(String title, String address, String phone, String email) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on, 'Address', address),
            _buildInfoRow(Icons.phone, 'Phone', phone),
            _buildInfoRow(Icons.email, 'Email', email),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(String name, IconData icon, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: () => _openSocialMedia(name),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement form submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message sent successfully! We will get back to you soon.'),
          backgroundColor: AppColors.success,
        ),
      );
      
      // Clear form
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
      setState(() {
        _selectedCategory = 'General Inquiry';
      });
    }
  }

  void _makePhoneCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening phone dialer...')),
    );
  }

  void _sendEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening email client...')),
    );
  }

  void _startLiveChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting live chat...')),
    );
  }

  void _openWhatsApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening WhatsApp...')),
    );
  }

  void _openSocialMedia(String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $platform...')),
    );
  }
}
