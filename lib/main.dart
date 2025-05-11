import 'package:flutter/material.dart';

import 'core/app/app.dart';
import 'core/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initDependencies();

  runApp(const ScanSplitApp());
}