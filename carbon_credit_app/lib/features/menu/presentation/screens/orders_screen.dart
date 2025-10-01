import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> _allOrders = [
    {
      'id': 'ORD-2024-001',
      'projectName': 'Sundarbans Mangrove Restoration',
      'credits': 25,
      'amount': 18000,
      'status': 'Pending',
      'date': '20 Jan 2024',
      'seller': 'Coastal Conservation Foundation',
      'type': 'Purchase',
    },
    {
      'id': 'ORD-2024-002',
      'projectName': 'Amazon Community Forestry',
      'credits': 50,
      'amount': 40000,
      'status': 'Processing',
      'date': '18 Jan 2024',
      'seller': 'Rainforest Alliance',
      'type': 'Purchase',
    },
    {
      'id': 'ORD-2023-045',
      'projectName': 'Reforestation Himachal',
      'credits': 30,
      'amount': 19500,
      'status': 'Completed',
      'date': '15 Jan 2024',
      'seller': 'Forest Revival Co.',
      'type': 'Purchase',
    },
    {
      'id': 'ORD-2023-044',
      'projectName': 'Coastal Mangrove Protection',
      'credits': 75,
      'amount': 54000,
      'status': 'Completed',
      'date': '12 Jan 2024',
      'seller': 'Marine Conservation Trust',
      'type': 'Purchase',
    },
    {
      'id': 'ORD-2023-043',
      'projectName': 'Forest Revival Project',
      'credits': 40,
      'amount': 28000,
      'status': 'Completed',
      'date': '8 Jan 2024',
      'seller': 'Green Earth Initiative',
      'type': 'Purchase',
    },
    {
      'id': 'ORD-2023-042',
      'projectName': 'Wind Energy Credits',
      'credits': 20,
      'amount': 15000,
      'status': 'Cancelled',
      'date': '5 Jan 2024',
      'seller': 'Renewable Energy Corp',
      'type': 'Purchase',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Order Summary Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Orders',
                    '${_allOrders.length}',
                    Icons.shopping_bag,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Total Amount',
                    '₹${_getTotalAmount()}',
                    Icons.currency_rupee,
                    AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          
          // Orders List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList(_allOrders),
                _buildOrdersList(_getOrdersByStatus('Pending')),
                _buildOrdersList(_getOrdersByStatus('Completed')),
                _buildOrdersList(_getOrdersByStatus('Cancelled')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.heading3.copyWith(color: color),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    Color statusColor = _getStatusColor(order['status']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['id'],
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    order['status'],
                    style: AppTextStyles.caption.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Project Details
            Text(
              order['projectName'],
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Seller: ${order['seller']}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),

            // Order Details
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Credits',
                        style: AppTextStyles.caption,
                      ),
                      Text(
                        '${order['credits']} credits',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount',
                        style: AppTextStyles.caption,
                      ),
                      Text(
                        '₹${order['amount']}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: AppTextStyles.caption,
                      ),
                      Text(
                        order['date'],
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showOrderDetails(order),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 12),
                if (order['status'] == 'Pending') ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showCancelOrderDialog(order),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ] else if (order['status'] == 'Completed') ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _downloadInvoice(order),
                      child: const Text('Download Invoice'),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: order['status'] == 'Cancelled' 
                          ? null 
                          : () => _trackOrder(order),
                      child: Text(order['status'] == 'Cancelled' ? 'Cancelled' : 'Track Order'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'processing':
        return AppColors.info;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  List<Map<String, dynamic>> _getOrdersByStatus(String status) {
    return _allOrders.where((order) => order['status'] == status).toList();
  }

  String _getTotalAmount() {
    int total = _allOrders
        .where((order) => order['status'] != 'Cancelled')
        .fold(0, (sum, order) => sum + (order['amount'] as int));
    return total.toString();
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Order ID', order['id']),
              _buildDetailRow('Project', order['projectName']),
              _buildDetailRow('Seller', order['seller']),
              _buildDetailRow('Credits', '${order['credits']} credits'),
              _buildDetailRow('Amount', '₹${order['amount']}'),
              _buildDetailRow('Status', order['status']),
              _buildDetailRow('Date', order['date']),
              _buildDetailRow('Type', order['type']),
            ],
          ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelOrderDialog(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Text('Are you sure you want to cancel order ${order['id']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                order['status'] = 'Cancelled';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order cancelled successfully')),
              );
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _downloadInvoice(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading invoice for ${order['id']}...'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {},
        ),
      ),
    );
  }

  void _trackOrder(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tracking order ${order['id']}...'),
      ),
    );
  }
}
