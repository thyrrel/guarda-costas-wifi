"import 'package:flutter/material.dart';
import 'package:guarda_costas_wifi/data/models/network_device_model.dart';
import 'package:guarda_costas_wifi/presentation/screens/main_scaffold.dart';
import 'package:guarda_costas_wifi/presentation/screens/admin_screen.dart';
import 'package:guarda_costas_wifi/presentation/screens/agent_control_screen.dart';
import 'package:guarda_costas_wifi/features/basic/presentation/screens/device_details_screen.dart';
import 'package:guarda_costas_wifi/features/vip/presentation/screens/security_analysis_screen.dart';
import 'package:guarda_costas_wifi/features/vip/presentation/screens/bulk_block_screen.dart';
import 'package:guarda_costas_wifi/features/adaptive_mode/presentation/screens/adaptive_mode_screen.dart';
import 'package:guarda_costas_wifi/features/blueprints/presentation/screens/blueprints_store_screen.dart';
import 'package:guarda_costas_wifi/features/concierge/presentation/screens/concierge_screen.dart';
import 'package:guarda_costas_wifi/features/family_dashboard/presentation/screens/family_dashboard_screen.dart';
import 'package:guarda_costas_wifi/features/family_profiles/presentation/screens/family_profiles_screen.dart';
import 'package:guarda_costas_wifi/features/reports/presentation/screens/network_report_screen.dart';
import 'package:guarda_costas_wifi/features/wellness/presentation/screens/wellness_integration_screen.dart';

class AppRouter {
  static const String mainRoute = '/';
  static const String adminRoute = '/admin';
  static const String agentControlRoute = '/admin/agent-control';
  static const String deviceDetailsRoute = '/device-details';
  static const String securityAnalysisRoute = '/admin/security-analysis';
  static const String bulkBlockRoute = '/admin/bulk-block';
  static const String networkReportRoute = '/admin/network-report';
  static const String adaptiveModeRoute = '/admin/adaptive-mode';
  static const String familyProfilesRoute = '/admin/family-profiles';
  static const String wellnessRoute = '/admin/wellness';
  static const String blueprintsRoute = '/blueprints';
  static const String conciergeRoute = '/concierge';
  static const String familyDashboardRoute = '/family-dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainRoute:
        return MaterialPageRoute(builder: (_) => const MainScaffold());
      case adminRoute:
        return MaterialPageRoute(builder: (_) => AdminScreen());
      case agentControlRoute:
        return MaterialPageRoute(builder: (_) => const AgentControlScreen());
      case deviceDetailsRoute:
        final device = settings.arguments as NetworkDeviceModel;
        return MaterialPageRoute(builder: (_) => DeviceDetailsScreen(device: device));
      case securityAnalysisRoute:
        return MaterialPageRoute(builder: (_) => const SecurityAnalysisScreen());
      case bulkBlockRoute:
        return MaterialPageRoute(builder: (_) => const BulkBlockScreen());
      case networkReportRoute:
        return MaterialPageRoute(builder: (_) => const NetworkReportScreen());
      case adaptiveModeRoute:
        return MaterialPageRoute(builder: (_) => const AdaptiveModeScreen());
      case familyProfilesRoute:
        return MaterialPageRoute(builder: (_) => const FamilyProfilesScreen());
      case wellnessRoute:
        return MaterialPageRoute(builder: (_) => const WellnessIntegrationScreen());
      case blueprintsRoute:
        return MaterialPageRoute(builder: (_) => const BlueprintsStoreScreen());
      case conciergeRoute:
        return MaterialPageRoute(builder: (_) => const ConciergeScreen());
      case familyDashboardRoute:
        return MaterialPageRoute(builder: (_) => const FamilyDashboardScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Rota não encontrada: ${settings.name}')),
          ),
        );
    }
  }
}"