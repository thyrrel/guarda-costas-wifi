import 'package:json_annotation/json_annotation.dart';
import 'package:guarda_costas_wifi/core/models/location_data.dart';
import 'package:guarda_costas_wifi/core/models/wifi_network.dart';

part 'monitoring_session.g.dart';

@JsonSerializable()
class MonitoringSession {
  final String id;
  final DateTime startTime;
  DateTime? endTime;
  final LocationData location;
  final List<WifiNetwork> detectedNetworks;
  final String status;

  MonitoringSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.location,
    required this.detectedNetworks,
    required this.status,
  });

  factory MonitoringSession.fromJson(Map<String, dynamic> json) =>
      _$MonitoringSessionFromJson(json);

  Map<String, dynamic> toJson() => _$MonitoringSessionToJson(this);

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }
}