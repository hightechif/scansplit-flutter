import 'package:flutter/material.dart';
import 'package:scansplit/core/router/app_router.dart';
import 'package:scansplit/core/theme/app_theme.dart';

class ScanSplitApp extends StatelessWidget {
  const ScanSplitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ScanSplit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Overlay(
            initialEntries: [OverlayEntry(builder: (_) => child!)],
          ),
        );
      },
    );
  }
}
