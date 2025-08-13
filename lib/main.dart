import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guarda_costas_wifi/core/providers/wifi_provider.dart';
import 'package:guarda_costas_wifi/core/providers/location_provider.dart';
import 'package:guarda_costas_wifi/core/providers/monitoring_provider.dart';
import 'package:guarda_costas_wifi/core/services/notification_service.dart';
import 'package:guarda_costas_wifi/core/utils/app_theme.dart';
import 'package:guarda_costas_wifi/features/home/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notification service
  await NotificationService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WifiProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => MonitoringProvider()),
      ],
      child: MaterialApp(
        title: 'Guarda-Costas WiFi',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}