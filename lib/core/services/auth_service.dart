"import 'package:shared_preferences/shared_preferences.dart';
import 'package:guarda_costas_wifi/core/enums/subscription_level.dart';

class AuthService {
  static const String _loggedInKey = 'is_logged_in';
  static const String _subscriptionLevelKey = 'subscription_level';

  Future<SubscriptionLevel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    SubscriptionLevel level;
    switch (password.toLowerCase()) {
      case 'vip':
        level = SubscriptionLevel.vip;
        break;
      case 'premium':
        level = SubscriptionLevel.premium;
        break;
      case 'ultra':
        level = SubscriptionLevel.ultra;
        break;
      default:
        level = SubscriptionLevel.basic;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_subscriptionLevelKey, level.name);
    return level;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
    await prefs.remove(_subscriptionLevelKey);
  }

  Future<(bool, SubscriptionLevel)> getAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_loggedInKey) ?? false;
    final levelString = prefs.getString(_subscriptionLevelKey) ?? SubscriptionLevel.basic.name;
    final level = SubscriptionLevel.values.firstWhere((e) => e.name == levelString, orElse: () => SubscriptionLevel.basic);
    return (isLoggedIn, level);
  }
}"