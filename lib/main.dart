import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'presentation/screens/splash_screen.dart';
import 'core/services/background_service_manager.dart';
import 'data/local/isar_database_manager.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enforce Landscape Orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Initialize Local Database
  await IsarDatabaseManager.init();

  // Initialize Background Service
  await BackgroundServiceManager.initializeService();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdScreen Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      navigatorObservers: [routeObserver],
      home: const SplashScreen(),
    );
  }
}
