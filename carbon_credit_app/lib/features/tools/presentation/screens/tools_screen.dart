import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class ToolsScreen extends ConsumerWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tools & Resources'),
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
            // Header
            Text(
              'Carbon Trading Tools',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              'Essential tools and resources for carbon credit trading',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Tools Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildToolCard(
                  context,
                  'Carbon Calculator',
                  'Calculate your carbon footprint',
                  Icons.calculate,
                  AppColors.primary,
                  () => _openCarbonCalculator(context),
                ),
                _buildToolCard(
                  context,
                  'Market News',
                  'Latest carbon market updates',
                  Icons.newspaper,
                  AppColors.info,
                  () => _openMarketNews(context),
                ),
                _buildToolCard(
                  context,
                  'UPI Payments',
                  'Quick payment solutions',
                  Icons.payment,
                  AppColors.success,
                  () => _openUPIPayments(context),
                ),
                _buildToolCard(
                  context,
                  'Reports & Analytics',
                  'Detailed trading reports',
                  Icons.bar_chart,
                  AppColors.warning,
                  () => _openReports(context),
                ),
                _buildToolCard(
                  context,
                  'Price Tracker',
                  'Track carbon credit prices',
                  Icons.trending_up,
                  AppColors.error,
                  () => _openPriceTracker(context),
                ),
                _buildToolCard(
                  context,
                  'Compliance Check',
                  'Verify compliance status',
                  Icons.verified_user,
                  AppColors.primary,
                  () => _openComplianceCheck(context),
                ),
                _buildToolCard(
                  context,
                  'Project Finder',
                  'Find carbon projects',
                  Icons.search,
                  AppColors.info,
                  () => _openProjectFinder(context),
                ),
                _buildToolCard(
                  context,
                  'Tax Calculator',
                  'Calculate tax implications',
                  Icons.receipt_long,
                  AppColors.success,
                  () => _openTaxCalculator(context),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Quick Resources
            Text(
              'Quick Resources',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 16),
            _buildResourceCard(
              'Carbon Trading Guide',
              'Complete guide to carbon credit trading',
              Icons.book,
              AppColors.primary,
              () => _openTradingGuide(context),
            ),
            _buildResourceCard(
              'Market Regulations',
              'Latest regulations and compliance requirements',
              Icons.gavel,
              AppColors.warning,
              () => _openRegulations(context),
            ),
            _buildResourceCard(
              'FAQ & Support',
              'Frequently asked questions and support',
              Icons.help,
              AppColors.info,
              () => _openFAQ(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _openCarbonCalculator(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CarbonCalculatorScreen(),
      ),
    );
  }

  void _openMarketNews(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MarketNewsScreen(),
      ),
    );
  }

  void _openUPIPayments(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UPIPaymentsScreen(),
      ),
    );
  }

  void _openReports(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReportsScreen(),
      ),
    );
  }

  void _openPriceTracker(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Price Tracker coming soon!')),
    );
  }

  void _openComplianceCheck(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Compliance Check coming soon!')),
    );
  }

  void _openProjectFinder(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project Finder coming soon!')),
    );
  }

  void _openTaxCalculator(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tax Calculator coming soon!')),
    );
  }

  void _openTradingGuide(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trading Guide coming soon!')),
    );
  }

  void _openRegulations(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Market Regulations coming soon!')),
    );
  }

  void _openFAQ(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('FAQ & Support coming soon!')),
    );
  }
}

// Individual Tool Screens
class CarbonCalculatorScreen extends StatefulWidget {
  const CarbonCalculatorScreen({super.key});

  @override
  State<CarbonCalculatorScreen> createState() => _CarbonCalculatorScreenState();
}

class _CarbonCalculatorScreenState extends State<CarbonCalculatorScreen> {
  final _electricityController = TextEditingController();
  final _gasController = TextEditingController();
  final _fuelController = TextEditingController();
  final _flightsController = TextEditingController();
  double _totalEmissions = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculate Your Carbon Footprint',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your monthly consumption to calculate emissions',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Input Fields
            _buildInputField(
              'Electricity (kWh)',
              _electricityController,
              'Enter monthly electricity usage',
            ),
            _buildInputField(
              'Natural Gas (cubic meters)',
              _gasController,
              'Enter monthly gas usage',
            ),
            _buildInputField(
              'Fuel (liters)',
              _fuelController,
              'Enter monthly fuel consumption',
            ),
            _buildInputField(
              'Flight Hours',
              _flightsController,
              'Enter monthly flight hours',
            ),
            const SizedBox(height: 24),

            // Calculate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateEmissions,
                child: const Text('Calculate Emissions'),
              ),
            ),
            const SizedBox(height: 24),

            // Results
            if (_totalEmissions > 0) ...[
              Card(
                color: AppColors.primary.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.eco,
                        color: AppColors.primary,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Total Monthly Emissions',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_totalEmissions.toStringAsFixed(2)} kg CO₂',
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Credits needed to offset: ${(_totalEmissions / 1000).toStringAsFixed(2)} credits',
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _calculateEmissions() {
    double electricity = double.tryParse(_electricityController.text) ?? 0;
    double gas = double.tryParse(_gasController.text) ?? 0;
    double fuel = double.tryParse(_fuelController.text) ?? 0;
    double flights = double.tryParse(_flightsController.text) ?? 0;

    // Simple emission factors (kg CO2 per unit)
    double electricityEmissions = electricity * 0.5; // 0.5 kg CO2 per kWh
    double gasEmissions = gas * 2.0; // 2.0 kg CO2 per cubic meter
    double fuelEmissions = fuel * 2.3; // 2.3 kg CO2 per liter
    double flightEmissions = flights * 90; // 90 kg CO2 per hour

    setState(() {
      _totalEmissions = electricityEmissions + gasEmissions + fuelEmissions + flightEmissions;
    });
  }

  @override
  void dispose() {
    _electricityController.dispose();
    _gasController.dispose();
    _fuelController.dispose();
    _flightsController.dispose();
    super.dispose();
  }
}

class MarketNewsScreen extends StatelessWidget {
  const MarketNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> news = [
      {
        'title': 'Global Carbon Market Reaches Record High',
        'summary': 'The global carbon credit market has reached unprecedented levels...',
        'date': '2024-01-20',
        'category': 'Market Update',
        'image': Icons.trending_up,
      },
      {
        'title': 'New EU Regulations for Carbon Trading',
        'summary': 'European Union announces new regulations affecting carbon credit trading...',
        'date': '2024-01-19',
        'category': 'Regulation',
        'image': Icons.gavel,
      },
      {
        'title': 'India Launches National Carbon Market',
        'summary': 'India officially launches its national carbon credit trading platform...',
        'date': '2024-01-18',
        'category': 'Policy',
        'image': Icons.flag,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market News'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: news.length,
        itemBuilder: (context, index) {
          final article = news[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        article['image'],
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          article['category'],
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        article['date'],
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    article['title'],
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article['summary'],
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Read More'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class UPIPaymentsScreen extends StatelessWidget {
  const UPIPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPI Payments'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Payment Solutions',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              'Fast and secure UPI payments for carbon credits',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // UPI Options
            _buildUPIOption(
              'Pay with UPI ID',
              'Enter UPI ID to make payment',
              Icons.alternate_email,
              AppColors.primary,
              () {},
            ),
            _buildUPIOption(
              'Scan QR Code',
              'Scan QR code for instant payment',
              Icons.qr_code_scanner,
              AppColors.success,
              () {},
            ),
            _buildUPIOption(
              'Phone Number',
              'Pay using registered phone number',
              Icons.phone,
              AppColors.info,
              () {},
            ),
            const SizedBox(height: 24),

            // Popular UPI Apps
            Text(
              'Popular UPI Apps',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildUPIApp('Google Pay', Icons.payment, AppColors.primary),
                _buildUPIApp('PhonePe', Icons.phone_android, AppColors.success),
                _buildUPIApp('Paytm', Icons.account_balance_wallet, AppColors.info),
                _buildUPIApp('BHIM', Icons.account_balance, AppColors.warning),
                _buildUPIApp('Amazon Pay', Icons.shopping_cart, AppColors.error),
                _buildUPIApp('Others', Icons.more_horiz, AppColors.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUPIOption(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildUPIApp(String name, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                name,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trading Reports',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              'Detailed analytics and reports for your carbon trading activity',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Report Types
            _buildReportCard(
              'Monthly Summary',
              'Complete monthly trading summary',
              Icons.calendar_month,
              AppColors.primary,
              'Last updated: Today',
            ),
            _buildReportCard(
              'Portfolio Analysis',
              'Detailed portfolio performance analysis',
              Icons.pie_chart,
              AppColors.success,
              'Last updated: 2 hours ago',
            ),
            _buildReportCard(
              'Tax Report',
              'Tax implications and calculations',
              Icons.receipt_long,
              AppColors.warning,
              'Last updated: Yesterday',
            ),
            _buildReportCard(
              'Compliance Report',
              'Regulatory compliance status',
              Icons.verified_user,
              AppColors.info,
              'Last updated: 3 days ago',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(String title, String description, IconData icon, Color color, String lastUpdated) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
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
                    ),
                  ),
                  Text(
                    description,
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastUpdated,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
