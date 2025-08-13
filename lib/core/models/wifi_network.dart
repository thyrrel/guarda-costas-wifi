import 'package:json_annotation/json_annotation.dart';

part 'wifi_network.g.dart';

@JsonSerializable()
class WifiNetwork {
  final String ssid;
  final String bssid;
  final int signalStrength;
  final String security;
  final int frequency;
  final bool isConnected;

  WifiNetwork({
    required this.ssid,
    required this.bssid,
    required this.signalStrength,
    required this.security,
    required this.frequency,
    this.isConnected = false,
  });

  factory WifiNetwork.fromJson(Map<String, dynamic> json) =>
      _$WifiNetworkFromJson(json);

  Map<String, dynamic> toJson() => _$WifiNetworkToJson(this);

  String get signalQuality {
    if (signalStrength >= -50) return 'Excelente';
    if (signalStrength >= -60) return 'Bom';
    if (signalStrength >= -70) return 'Regular';
    return 'Fraco';
  }
}