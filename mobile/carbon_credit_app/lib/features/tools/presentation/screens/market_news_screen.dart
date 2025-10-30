import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class MarketNewsScreen extends ConsumerStatefulWidget {
  const MarketNewsScreen({super.key});

  @override
  ConsumerState<MarketNewsScreen> createState() => _MarketNewsScreenState();
}

class _MarketNewsScreenState extends ConsumerState<MarketNewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> _newsArticles = [
    {
      'title': 'Carbon Credit Prices Surge 25% in Q4 2024',
      'summary': 'Voluntary carbon market sees unprecedented growth as corporate demand increases.',
      'category': 'Market',
      'time': '2 hours ago',
      'source': 'Carbon Market Watch',
      'trending': true,
      'image': Icons.trending_up,
      'color': AppColors.success,
    },
    {
      'title': 'New REDD+ Projects Launch in Amazon Basin',
      'summary': 'Three new forest conservation projects receive international certification.',
      'category': 'Projects',
      'time': '4 hours ago',
      'source': 'Forest Carbon News',
      'trending': false,
      'image': Icons.forest,
      'color': AppColors.primary,
    },
    {
      'title': 'India Announces Enhanced Carbon Trading Framework',
      'summary': 'Government unveils new regulations to boost domestic carbon market participation.',
      'category': 'Policy',
      'time': '6 hours ago',
      'source': 'Policy Today',
      'trending': true,
      'image': Icons.policy,
      'color': AppColors.info,
    },
    {
      'title': 'Tech Giants Commit to Net-Zero by 2030',
      'summary': 'Major technology companies pledge massive carbon credit purchases.',
      'category': 'Corporate',
      'time': '8 hours ago',
      'source': 'Tech Climate',
      'trending': false,
      'image': Icons.business,
      'color': AppColors.warning,
    },
    {
      'title': 'Blockchain Verification Reduces Credit Fraud by 40%',
      'summary': 'New technology implementation shows promising results in market integrity.',
      'category': 'Technology',
      'time': '12 hours ago',
      'source': 'Blockchain Carbon',
      'trending': false,
      'image': Icons.security,
      'color': AppColors.secondary,
    },
  ];

  final List<Map<String, dynamic>> _marketData = [
    {
      'standard': 'VCS',
      'price': '₹850',
      'change': '+5.2%',
      'volume': '2.3M',
      'isPositive': true,
    },
    {
      'standard': 'Gold Standard',
      'price': '₹920',
      'change': '+3.8%',
      'volume': '1.8M',
      'isPositive': true,
    },
    {
      'standard': 'CDM',
      'price': '₹680',
      'change': '-1.2%',
      'volume': '1.1M',
      'isPositive': false,
    },
    {
      'standard': 'CAR',
      'price': '₹780',
      'change': '+2.1%',
      'volume': '0.9M',
      'isPositive': true,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market News & Insights'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Latest News', icon: Icon(Icons.article)),
            Tab(text: 'Market Data', icon: Icon(Icons.show_chart)),
            Tab(text: 'Analysis', icon: Icon(Icons.analytics)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNewsTab(),
          _buildMarketDataTab(),
          _buildAnalysisTab(),
        ],
      ),
    );
  }

  Widget _buildNewsTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('News updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _newsArticles.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildTrendingSection();
          }
          
          final article = _newsArticles[index - 1];
          return _buildNewsCard(article);
        },
      ),
    );
  }

  Widget _buildTrendingSection() {
    final trendingNews = _newsArticles.where((article) => article['trending']).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.whatshot, color: AppColors.error),
            const SizedBox(width: 8),
            Text(
              'Trending Now',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: trendingNews.length,
            itemBuilder: (context, index) {
              final article = trendingNews[index];
              return _buildTrendingCard(article);
            },
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'All News',
          style: AppTextStyles.heading3,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTrendingCard(Map<String, dynamic> article) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        color: AppColors.error.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(article['image'], color: article['color'], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      article['title'],
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                article['summary'],
                style: AppTextStyles.caption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    article['source'],
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    article['time'],
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showArticleDetails(article),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: article['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  article['image'],
                  color: article['color'],
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: article['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            article['category'],
                            style: AppTextStyles.caption.copyWith(
                              color: article['color'],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (article['trending']) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.whatshot, color: AppColors.error, size: 16),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article['title'],
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article['summary'],
                      style: AppTextStyles.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          article['source'],
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          article['time'],
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarketDataTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live Market Prices',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),
          
          ...List.generate(_marketData.length, (index) {
            final data = _marketData[index];
            return _buildMarketCard(data);
          }),
          
          const SizedBox(height: 24),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Market Summary',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Total Volume (24h)', '6.1M credits'),
                  _buildSummaryRow('Average Price', '₹807'),
                  _buildSummaryRow('Market Cap', '₹4.9B'),
                  _buildSummaryRow('Active Projects', '1,247'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketCard(Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['standard'],
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Volume: ${data['volume']}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data['price'],
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: data['isPositive'] 
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    data['change'],
                    style: AppTextStyles.caption.copyWith(
                      color: data['isPositive'] ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Market Analysis',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),
          
          _buildAnalysisCard(
            'Weekly Outlook',
            'Carbon credit prices expected to remain stable with slight upward pressure from increased corporate demand.',
            Icons.trending_up,
            AppColors.success,
          ),
          
          _buildAnalysisCard(
            'Sector Performance',
            'Renewable energy projects outperforming forestry credits by 12% this quarter.',
            Icons.energy_savings_leaf,
            AppColors.primary,
          ),
          
          _buildAnalysisCard(
            'Regional Trends',
            'Asian markets showing strongest growth with 35% increase in trading volume.',
            Icons.public,
            AppColors.info,
          ),
          
          _buildAnalysisCard(
            'Risk Assessment',
            'Low volatility expected due to stable regulatory environment and consistent demand.',
            Icons.security,
            AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard(String title, String content, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
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
                  const SizedBox(height: 8),
                  Text(
                    content,
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

  void _showArticleDetails(Map<String, dynamic> article) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(article['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article['summary'],
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'This is a detailed view of the news article. In a full implementation, this would show the complete article content, images, and related links.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Source: ${article['source']}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  article['time'],
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Read Full Article'),
          ),
        ],
      ),
    );
  }
}
