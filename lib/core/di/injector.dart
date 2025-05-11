// lib/core/di/injector.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Register shared preferences
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPrefs);

  /*// Register services
  getIt.registerSingleton<AuthService>(FirebaseAuthService());
  getIt.registerSingleton<ReceiptApi>(ReceiptApiImpl());
  getIt.registerSingleton<AppRouter>(AppRouter());

  // Register repositories
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl(getIt()));
  getIt.registerSingleton<ReceiptRepository>(ReceiptRepositoryImpl(getIt()));*/
}