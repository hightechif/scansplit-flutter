// lib/core/router/app_router.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:scansplit/features/camera/presentation/screens/camera_screen.dart';
import 'package:scansplit/features/common/presentation/home_screen.dart';
import 'package:scansplit/features/common/presentation/splash_screen.dart';
import 'package:scansplit/features/receipt/domain/models/receipt.dart';
import 'package:scansplit/features/receipt/presentation/screens/receipt_detail_screen.dart';
import 'package:scansplit/features/receipt/presentation/screens/receipt_review_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/camera',
        builder: (context, state) => CameraScreen(
          onImageCaptured: (imagePath) {
            // This will be called when image is captured
            context.push('/receipt-review', extra: {
              'imagePath': imagePath,
              'onRetake': () => {
                if (context.canPop()) {
                  context.pop()
                } else {
                  context.go('/camera')
                }
              },
              'onAccept': (receipt) {
                // Handle the accepted receipt (save to database, etc.)
                // Then navigate to appropriate screen
                context.push('/receipt/${receipt.id}');
              },
            });
          },
        ),
      ),
      // Receipt review screen
      GoRoute(
        path: '/receipt-review',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          assert(args.containsKey('imagePath'));
          assert(args.containsKey('onRetake'));
          assert(args.containsKey('onAccept'));
          return ReceiptReviewScreen(
            imagePath: args['imagePath'] as String,
            onRetake: args['onRetake'] as VoidCallback,
            onAccept: args['onAccept'] as Function(Receipt),
          );
        },
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
    observers: [MyRouteObserver()],
  );
}

class MyRouteObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    if (kDebugMode) {
      print('Popped route: ${route.settings.name}');
    }
  }
}
