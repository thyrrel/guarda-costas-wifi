import 'package:json_annotation/json_annotation.dart';

part 'location_data.g.dart';

@JsonSerializable()
class LocationData {
  final double latitude;
  final double longitude;
  final double accuracy;
  final DateTime? timestamp;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    this.timestamp,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDataToJson(this);
}