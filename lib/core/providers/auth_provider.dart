import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final String? token;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.token,
  });

  bool get isAuthenticated => user != null && token != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    String? token,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;

  AuthNotifier(this._apiService) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _apiService.login(email, password);
      
      if (response['success'] == true) {
        final user = User.fromJson(response['user']);
        final token = response['token'] as String;
        
        state = state.copyWith(
          user: user,
          token: token,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  Future<void> register(String email, String password, String name, UserRole role) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _apiService.register(email, password, name, role);
      
      if (response['success'] == true) {
        final user = User.fromJson(response['user']);
        final token = response['token'] as String;
        
        state = state.copyWith(
          user: user,
          token: token,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response['message'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  void logout() {
    state = const AuthState();
  }

  void updateKYCStatus(String status) {
    if (state.user != null) {
      state = state.copyWith(
        user: state.user!.copyWith(kycStatus: status),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ApiService());
});
