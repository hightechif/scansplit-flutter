// lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:scansplit/features/camera/presentation/screens/camera_screen.dart';
import 'package:scansplit/features/common/presentation/home_screen.dart';
import 'package:scansplit/features/common/presentation/splash_screen.dart';
import 'package:scansplit/features/receipt/domain/models/receipt.dart';
import 'package:scansplit/features/receipt/presentation/screens/receipt_detail_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/camera',
        builder: (context, state) => const CameraScreen(),
      ),
      // Receipt details screen
      GoRoute(
        path: '/receipts/:receiptId',
        builder: (context, state) {
          final receiptId = state.pathParameters['receiptId']!;
          final receipt = state.extra as Receipt;
          return ReceiptDetailsScreen(receipt: receipt);
        },
      ),
    ],
    errorBuilder: (context, state) => const HomeScreen(),
  );
}
