import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/landing_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/sector_industry_screen.dart';
import '../../features/auth/presentation/screens/company_details_screen.dart';
import '../../features/auth/presentation/screens/waitlist_screen.dart';
import '../../features/kyc/presentation/screens/kyc_upload_screen.dart';
import '../../features/kyc/presentation/screens/aadhaar_verify_screen.dart';
import '../../features/kyc/presentation/screens/pan_verify_screen.dart';
import '../../features/kyc/presentation/screens/kyc_waiting_screen.dart';
import '../../features/dashboard/presentation/screens/buyer_dashboard.dart';
import '../../features/dashboard/presentation/screens/seller_dashboard.dart';
import '../../features/marketplace/presentation/screens/marketplace_screen.dart';
import '../../features/marketplace/presentation/screens/credit_detail_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/cart/presentation/screens/checkout_screen.dart';
import '../../features/certificates/presentation/screens/certificates_screen.dart';
import '../../features/dashboard/presentation/screens/credit_detail_page.dart';
import '../../features/dashboard/presentation/screens/certificate_detail_page.dart';
import '../../features/dashboard/presentation/screens/order_detail_page.dart';
import '../../features/menu/presentation/screens/account_screen.dart';
import '../../features/menu/presentation/screens/payment_options_screen.dart';
import '../../features/menu/presentation/screens/orders_screen.dart';
import '../../features/menu/presentation/screens/settings_screen.dart';
import '../../features/menu/presentation/screens/contact_us_screen.dart';
import '../../features/menu/presentation/screens/wallet_screen.dart' as menu_wallet;
import '../../features/tools/presentation/screens/tools_screen.dart';
import '../../features/kyc/presentation/screens/mrv_certificate_screen.dart';
import '../../features/dashboard/presentation/screens/selling_units_detail_screen.dart';
import '../../features/dashboard/presentation/screens/create_listing_screen.dart';
import '../../features/dashboard/presentation/screens/view_analytics_screen.dart';
import '../../features/dashboard/presentation/screens/pricing_tool_screen.dart';
import '../../features/dashboard/presentation/screens/compliance_check_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/sector-industry',
        builder: (context, state) => const SectorIndustryScreen(),
      ),
      GoRoute(
        path: '/company-details',
        builder: (context, state) => const CompanyDetailsScreen(),
      ),
      GoRoute(
        path: '/waitlist',
        builder: (context, state) => const WaitlistScreen(),
      ),
      GoRoute(
        path: '/kyc/upload',
        builder: (context, state) => const KYCUploadScreen(),
      ),
      GoRoute(
        path: '/kyc/aadhaar-verify',
        builder: (context, state) => const AadhaarVerifyScreen(),
      ),
      GoRoute(
        path: '/kyc/pan-verify',
        builder: (context, state) => const PanVerifyScreen(),
      ),
      GoRoute(
        path: '/kyc/waiting',
        builder: (context, state) => const KYCWaitingScreen(),
      ),
      GoRoute(
        path: '/kyc/mrv-certificate',
        builder: (context, state) => const MRVCertificateScreen(),
      ),
      GoRoute(
        path: '/dashboard/buyer',
        builder: (context, state) => const BuyerDashboard(),
      ),
      GoRoute(
        path: '/dashboard/seller',
        builder: (context, state) => const SellerDashboard(),
      ),
      // DEMO: Add simplified dashboard routes for demo functionality
      GoRoute(
        path: '/buyer-dashboard',
        builder: (context, state) => const BuyerDashboard(),
      ),
      GoRoute(
        path: '/seller-dashboard',
        builder: (context, state) => const SellerDashboard(),
      ),
      GoRoute(
        path: '/marketplace',
        builder: (context, state) => const MarketplaceScreen(),
      ),
      GoRoute(
        path: '/marketplace/credit/:id',
        builder: (context, state) => CreditDetailScreen(
          creditId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/certificates',
        builder: (context, state) => const CertificatesScreen(),
      ),
      GoRoute(
        path: '/wallet',
        builder: (context, state) => const menu_wallet.WalletScreen(),
      ),
      GoRoute(
        path: '/credit-detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>;
          return CreditDetailPage(
            projectName: extra['projectName']!,
            sellerName: extra['sellerName']!,
            price: extra['price']!,
            location: extra['location']!,
          );
        },
      ),
      GoRoute(
        path: '/certificate-detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>;
          return CertificateDetailPage(
            projectName: extra['projectName']!,
            credits: extra['credits']!,
            amount: extra['amount']!,
            date: extra['date']!,
          );
        },
      ),
      GoRoute(
        path: '/order-detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>;
          return OrderDetailPage(
            orderId: extra['orderId']!,
            projectName: extra['projectName']!,
            credits: extra['credits']!,
            amount: extra['amount']!,
            status: extra['status']!,
            date: extra['date']!,
          );
        },
      ),
      // Menu Routes
      GoRoute(
        path: '/account',
        builder: (context, state) => const AccountScreen(),
      ),
      GoRoute(
        path: '/payment-options',
        builder: (context, state) => const PaymentOptionsScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/contact-us',
        builder: (context, state) => const ContactUsScreen(),
      ),
      GoRoute(
        path: '/tools',
        builder: (context, state) => const ToolsScreen(),
      ),
      // Seller Dashboard Internal Routes
      GoRoute(
        path: '/selling-units-detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return SellingUnitsDetailScreen(
            projectName: extra?['projectName'] ?? 'Solar Farm Maharashtra',
            projectType: extra?['projectType'] ?? 'Renewable Energy',
            location: extra?['location'] ?? 'Maharashtra, India',
            totalCredits: extra?['totalCredits'] ?? 1000,
            availableCredits: extra?['availableCredits'] ?? 750,
            soldCredits: extra?['soldCredits'] ?? 250,
            pricePerCredit: extra?['pricePerCredit'] ?? 850.0,
            status: extra?['status'] ?? 'Active',
            lastSale: extra?['lastSale'] ?? '2 days ago',
          );
        },
      ),
      GoRoute(
        path: '/create-listing',
        builder: (context, state) => const CreateListingScreen(),
      ),
      GoRoute(
        path: '/view-analytics',
        builder: (context, state) => const ViewAnalyticsScreen(),
      ),
      GoRoute(
        path: '/pricing-tool',
        builder: (context, state) => const PricingToolScreen(),
      ),
      GoRoute(
        path: '/compliance-check',
        builder: (context, state) => const ComplianceCheckScreen(),
      ),
    ],
  );
});
