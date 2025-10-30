import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credit_listing.dart';
import '../services/api_service.dart';

class MarketplaceFilter {
  final String? projectType;
  final String? location;
  final double? minPrice;
  final double? maxPrice;

  const MarketplaceFilter({
    this.projectType,
    this.location,
    this.minPrice,
    this.maxPrice,
  });

  MarketplaceFilter copyWith({
    String? projectType,
    String? location,
    double? minPrice,
    double? maxPrice,
  }) {
    return MarketplaceFilter(
      projectType: projectType ?? this.projectType,
      location: location ?? this.location,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
}

final marketplaceFilterProvider = StateProvider<MarketplaceFilter>((ref) {
  return const MarketplaceFilter();
});

final marketplaceProvider = FutureProvider<List<CreditListing>>((ref) async {
  final filter = ref.watch(marketplaceFilterProvider);
  final apiService = ApiService();
  
  return await apiService.getListings(
    projectType: filter.projectType,
    location: filter.location,
    minPrice: filter.minPrice,
    maxPrice: filter.maxPrice,
  );
});

final filteredMarketplaceProvider = Provider<AsyncValue<List<CreditListing>>>((ref) {
  return ref.watch(marketplaceProvider);
});
