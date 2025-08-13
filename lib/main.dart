import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guarda_costas_wifi/config/routes/app_router.dart';
import 'package:guarda_costas_wifi/config/theme/app_theme.dart';
import 'package:guarda_costas_wifi/presentation/providers/theme_provider.dart';
import 'package:guarda_costas_wifi/presentation/providers/auth_provider.dart';
import 'package:guarda_costas_wifi/presentation/providers/agent_provider.dart';
import 'package:guarda_costas_wifi/features/basic/presentation/providers/home_provider.dart';
import 'package:guarda_costas_wifi/features/device_security/presentation/providers/device_security_provider.dart';
import 'package:guarda_costas_wifi/features/vip/presentation/providers/vip_provider.dart';
import 'package:guarda_costas_wifi/presentation/screens/login_screen.dart';
import 'package:guarda_costas_wifi/presentation/screens/main_scaffold.dart';
import 'package:guarda_costas_wifi/core/widgets/loading_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AgentProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => DeviceSecurityProvider()),
        ChangeNotifierProvider(create: (_) => VipProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Guarda-Costas WiFi',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(themeProvider.primaryColor),
            darkTheme: AppTheme.darkTheme(themeProvider.primaryColor),
            themeMode: themeProvider.themeMode,
            home: const AuthWrapper(),
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const Scaffold(body: LoadingIndicator());
        }
        if (authProvider.isLoggedIn) {
          return const MainScaffold();
        }
        return const LoginScreen();
      },
    );
  }
}