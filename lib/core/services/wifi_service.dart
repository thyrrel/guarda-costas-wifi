import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:guarda_costas_wifi/core/models/wifi_network.dart';

class WifiService {
  Future<List<WifiNetwork>> scanNetworks() async {
    await _requestPermissions();
    
    try {
      final networks = await WiFiForIoTPlugin.loadWifiList();
      return networks.map((network) => WifiNetwork(
        ssid: network.ssid ?? '',
        bssid: network.bssid ?? '',
        signalStrength: network.level ?? -100,
        security: network.capabilities ?? '',
        frequency: 0, // WiFiForIoTPlugin doesn't provide frequency
      )).toList();
    } catch (e) {
      throw Exception('Erro ao escanear redes: $e');
    }
  }

  Future<WifiNetwork?> getCurrentNetwork() async {
    try {
      final ssid = await WiFiForIoTPlugin.getSSID();
      final bssid = await WiFiForIoTPlugin.getBSSID();
      
      if (ssid != null && bssid != null) {
        return WifiNetwork(
          ssid: ssid,
          bssid: bssid,
          signalStrength: 0,
          security: '',
          frequency: 0,
          isConnected: true,
        );
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  Future<bool> connectToNetwork(String ssid, String password) async {
    await _requestPermissions();
    
    try {
      return await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: NetworkSecurity.WPA,
      );
    } catch (e) {
      throw Exception('Erro ao conectar à rede: $e');
    }
  }

  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.locationWhenInUse,
      Permission.nearbyWifiDevices,
    ];

    for (final permission in permissions) {
      if (await permission.isDenied) {
        await permission.request();
      }
    }
  }
}