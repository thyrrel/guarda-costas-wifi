import 'package:flutter/foundation.dart';
import 'package:guarda_costas_wifi/core/models/monitoring_session.dart';
import 'package:guarda_costas_wifi/core/services/monitoring_service.dart';

class MonitoringProvider with ChangeNotifier {
  final MonitoringService _monitoringService = MonitoringService();
  
  List<MonitoringSession> _activeSessions = [];
  bool _isMonitoring = false;
  
  List<MonitoringSession> get activeSessions => _activeSessions;
  bool get isMonitoring => _isMonitoring;

  Future<void> startMonitoring() async {
    _isMonitoring = true;
    notifyListeners();
    
    await _monitoringService.startMonitoring();
  }

  Future<void> stopMonitoring() async {
    _isMonitoring = false;
    notifyListeners();
    
    await _monitoringService.stopMonitoring();
  }

  void addSession(MonitoringSession session) {
    _activeSessions.add(session);
    notifyListeners();
  }

  void removeSession(String sessionId) {
    _activeSessions.removeWhere((session) => session.id == sessionId);
    notifyListeners();
  }
}