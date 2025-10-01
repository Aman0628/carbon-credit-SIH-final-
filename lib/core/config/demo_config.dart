/// Demo Configuration
/// 
/// This file contains configuration for demo features that can be easily 
/// enabled/disabled during development. 
/// 
/// TO REMOVE DEMO FEATURES:
/// 1. Set ENABLE_DEMO_MODE to false
/// 2. Remove this file and all references to it
/// 3. Search for "DEMO:" comments in the codebase and remove those sections

class DemoConfig {
  /// Master switch for all demo features
  /// Set to false to disable all demo functionality
  static const bool ENABLE_DEMO_MODE = true;
  
  /// Enable skip buttons in registration flow
  static const bool ENABLE_REGISTRATION_SKIP = ENABLE_DEMO_MODE && true;
  
  /// Enable skip buttons in KYC flow  
  static const bool ENABLE_KYC_SKIP = ENABLE_DEMO_MODE && true;
  
  /// Enable quick demo login
  static const bool ENABLE_DEMO_LOGIN = ENABLE_DEMO_MODE && true;
  
  /// Demo user credentials
  static const String DEMO_BUYER_EMAIL = 'demo.buyer@carbontrading.com';
  static const String DEMO_SELLER_EMAIL = 'demo.seller@carbontrading.com';
  static const String DEMO_PASSWORD = 'demo123';
  
  /// Demo user data
  static const Map<String, dynamic> DEMO_BUYER_DATA = {
    'name': 'Demo Buyer',
    'email': DEMO_BUYER_EMAIL,
    'phone': '9876543210',
    'role': 'buyer',
    'sector': 'Manufacturing',
    'industry': 'Steel & Iron',
    'isKycCompleted': true,
  };
  
  static const Map<String, dynamic> DEMO_SELLER_DATA = {
    'name': 'Demo Seller',
    'email': DEMO_SELLER_EMAIL,
    'phone': '9876543211', 
    'role': 'seller',
    'isKycCompleted': true,
  };
}
