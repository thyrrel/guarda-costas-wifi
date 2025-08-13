import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guarda_costas_wifi/core/models/location_data.dart';

class LocationProvider with ChangeNotifier {
  LocationData? _currentLocation;
  bool _isLoading = false;
  String? _errorMessage;

  LocationData? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Serviços de localização desabilitados');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permissões de localização negadas');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permissões de localização negadas permanentemente');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentLocation = LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        timestamp: position.timestamp,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}