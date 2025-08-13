"import 'package:guarda_costas_wifi/core/enums/device_type.dart';

class NetworkDeviceModel {
  final String id;
  final String? name;
  final String ipAddress;
  final String macAddress;
  final String? manufacturer;
  final DeviceType type;
  final bool isBlocked;
  final bool isFavorite;
  final DateTime firstSeen;
  final DateTime lastSeen;
  final int? iconCodepoint;

  NetworkDeviceModel({
    required this.id,
    this.name,
    required this.ipAddress,
    required this.macAddress,
    this.manufacturer,
    required this.type,
    required this.isBlocked,
    required this.isFavorite,
    required this.firstSeen,
    required this.lastSeen,
    this.iconCodepoint,
  });

  NetworkDeviceModel copyWith({
    String? id,
    String? name,
    String? ipAddress,
    String? macAddress,
    String? manufacturer,
    DeviceType? type,
    bool? isBlocked,
    bool? isFavorite,
    DateTime? firstSeen,
    DateTime? lastSeen,
    int? iconCodepoint,
  }) {
    return NetworkDeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ipAddress: ipAddress ?? this.ipAddress,
      macAddress: macAddress ?? this.macAddress,
      manufacturer: manufacturer ?? this.manufacturer,
      type: type ?? this.type,
      isBlocked: isBlocked ?? this.isBlocked,
      isFavorite: isFavorite ?? this.isFavorite,
      firstSeen: firstSeen ?? this.firstSeen,
      lastSeen: lastSeen ?? this.lastSeen,
      iconCodepoint: iconCodepoint ?? this.iconCodepoint,
    );
  }

  factory NetworkDeviceModel.fromJson(Map<String, dynamic> json) {
    return NetworkDeviceModel(
      id: json['macAddress'],
      macAddress: json['macAddress'],
      ipAddress: json['ipAddress'],
      name: json['hostname'],
      isBlocked: json['isBlocked'] ?? false,
      manufacturer: 'Desconhecido',
      type: DeviceType.UNKNOWN,
      isFavorite: false,
      firstSeen: DateTime.now(),
      lastSeen: DateTime.now(),
    );
  }
}"