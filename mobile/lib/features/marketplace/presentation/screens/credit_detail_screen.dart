import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/credit_listing.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/providers/cart_provider.dart';

class CreditDetailScreen extends ConsumerStatefulWidget {
  final String creditId;
  
  const CreditDetailScreen({
    super.key,
    required this.creditId,
  });

  @override
  ConsumerState<CreditDetailScreen> createState() => _CreditDetailScreenState();
}

class _CreditDetailScreenState extends ConsumerState<CreditDetailScreen> {
  int _quantity = 1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/marketplace'),
        ),
      ),
      body: FutureBuilder<CreditListing?>(
        future: ApiService().getListingById(widget.creditId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Credit not found',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/marketplace'),
                    child: const Text('Back to Marketplace'),
                  ),
                ],
              ),
            );
          }

          final listing = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.8),
                        AppColors.secondary.withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.eco,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Header
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listing.projectName,
                                  style: AppTextStyles.heading2,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  listing.location,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              listing.projectType,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Price Card
                      Card(
                        color: AppColors.primary.withOpacity(0.05),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '₹${listing.pricePerCredit.toStringAsFixed(0)}',
                                      style: AppTextStyles.heading1.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Text(
                                      'per credit',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${listing.availableCredits}',
                                    style: AppTextStyles.heading3,
                                  ),
                                  Text(
                                    'credits available',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Price History
                      Text(
                        'Price History (Last 30 Days)',
                        style: AppTextStyles.heading3,
                      ),
                      const SizedBox(height: 12),
                      _buildPriceHistoryCard(),
                      const SizedBox(height: 20),
                      
                      // Quantity Selector
                      Text(
                        'Quantity',
                        style: AppTextStyles.heading3,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                            icon: const Icon(Icons.remove),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.divider,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _quantity.toString(),
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: _quantity < listing.availableCredits
                                ? () => setState(() => _quantity++)
                                : null,
                            icon: const Icon(Icons.add),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Total: ₹${(listing.pricePerCredit * _quantity).toStringAsFixed(0)}',
                            style: AppTextStyles.heading3.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Description
                      Text(
                        'Project Description',
                        style: AppTextStyles.heading3,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        listing.description,
                        style: AppTextStyles.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      
                      // Impact Metrics
                      Text(
                        'Environmental Impact',
                        style: AppTextStyles.heading3,
                      ),
                      const SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildMetricRow(
                                'CO₂ Reduction',
                                listing.projectDetails['co2_reduction'] ?? 'N/A',
                                Icons.eco,
                              ),
                              const Divider(),
                              _buildMetricRow(
                                'Project Capacity',
                                listing.projectDetails['capacity'] ?? 'N/A',
                                Icons.bolt,
                              ),
                              const Divider(),
                              _buildMetricRow(
                                'Annual Generation',
                                listing.projectDetails['annual_generation'] ?? 'N/A',
                                Icons.trending_up,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Certification Info
                      Text(
                        'Certification',
                        style: AppTextStyles.heading3,
                      ),
                      const SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.verified,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          listing.certificationBody,
                                          style: AppTextStyles.bodyLarge.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Standard: ${listing.certificationStandard}',
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: AppColors.info,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Vintage Year: ${listing.vintageYear.year}',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Seller Information
                      Text(
                        'Seller Information',
                        style: AppTextStyles.heading3,
                      ),
                      const SizedBox(height: 12),
                      _buildSellerInfoCard(listing.sellerName),
                      const SizedBox(height: 32),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isLoading ? null : () => _addToCart(listing),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Add to Cart'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : () => _buyNow(listing),
                              child: const Text('Buy Now'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(CreditListing listing) {
    setState(() => _isLoading = true);
    
    ref.read(cartProvider.notifier).addToCart(listing, _quantity);
    
    setState(() => _isLoading = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $_quantity credits to cart'),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => context.go('/cart'),
        ),
      ),
    );
  }

  void _buyNow(CreditListing listing) {
    ref.read(cartProvider.notifier).clearCart();
    ref.read(cartProvider.notifier).addToCart(listing, _quantity);
    context.go('/checkout');
  }

  Widget _buildPriceHistoryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 150,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 3),
                    FlSpot(2.6, 2),
                    FlSpot(4.9, 5),
                    FlSpot(6.8, 3.1),
                    FlSpot(8, 4),
                    FlSpot(9.5, 3),
                    FlSpot(11, 4),
                  ],
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSellerInfoCard(String sellerName) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.storefront),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sellerName, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                      const Text('Verified Seller', style: AppTextStyles.caption),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSellerStat('Rating', '4.8/5 (127 reviews)'),
                _buildSellerStat('Response Time', '95% (within 24h)'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSellerStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
