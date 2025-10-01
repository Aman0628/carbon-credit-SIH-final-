import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credit_listing.dart';
import '../services/api_service.dart';

class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * 0.18; // 18% GST
  double get total => subtotal + tax;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final ApiService _apiService;

  CartNotifier(this._apiService) : super(const CartState());

  void addToCart(CreditListing listing, int quantity) {
    final existingIndex = state.items.indexWhere((item) => item.listingId == listing.id);
    
    if (existingIndex >= 0) {
      // Update existing item
      final updatedItems = [...state.items];
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      // Add new item
      final newItem = CartItem(
        listingId: listing.id,
        listing: listing,
        quantity: quantity,
        addedAt: DateTime.now(),
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
  }

  void updateQuantity(String listingId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(listingId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.listingId == listingId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void removeFromCart(String listingId) {
    final updatedItems = state.items.where((item) => item.listingId != listingId).toList();
    state = state.copyWith(items: updatedItems);
  }

  void clearCart() {
    state = state.copyWith(items: []);
  }

  Future<Map<String, dynamic>> processCheckout(String paymentMethod) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final items = state.items.map((item) => {
        'listing_id': item.listingId,
        'quantity': item.quantity,
        'price': item.listing.pricePerCredit,
      }).toList();
      
      final result = await _apiService.processCheckout(items, paymentMethod);
      
      if (result['success'] == true) {
        // Clear cart on successful checkout
        state = const CartState();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['message'] ?? 'Checkout failed',
        );
      }
      
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error: ${e.toString()}',
      );
      return {'success': false, 'message': e.toString()};
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ApiService());
});
