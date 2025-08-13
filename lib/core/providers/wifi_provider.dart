import 'package:flutter/foundation.dart';
import 'package:guarda_costas_wifi/core/models/wifi_network.dart';
import 'package:guarda_costas_wifi/core/services/wifi_service.dart';

class WifiProvider with ChangeNotifier {
  final WifiService _wifiService = WifiService();
  
  List<WifiNetwork> _availableNetworks = [];
  WifiNetwork? _connectedNetwork;
  bool _isScanning = false;
  String? _errorMessage;

  List<WifiNetwork> get availableNetworks => _availableNetworks;
  WifiNetwork? get connectedNetwork => _connectedNetwork;
  bool get isScanning => _isScanning;
  String? get errorMessage => _errorMessage;

  Future<void> scanNetworks() async {
    _isScanning = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _availableNetworks = await _wifiService.scanNetworks();
      _connectedNetwork = await _wifiService.getCurrentNetwork();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  Future<bool> connectToNetwork(String ssid, String password) async {
    try {
      final success = await _wifiService.connectToNetwork(ssid, password);
      if (success) {
        await scanNetworks();
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}