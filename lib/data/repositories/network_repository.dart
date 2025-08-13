"import 'package:guarda_costas_wifi/data/datasources/network_datasource.dart';
import 'package:guarda_costas_wifi/data/models/network_device_model.dart';
import 'package:guarda_costas_wifi/api/mac_vendor_api.dart';

class NetworkRepository {
  final NetworkDataSource _dataSource = NetworkDataSourceImpl();
  final MacVendorApi _vendorApi = MacVendorApi();

  Future<List<NetworkDeviceModel>> getDiscoveredDevices() async {
    try {
      final devices = await _dataSource.discoverDevices();
      // Enriquecer com dados do fabricante
      final enrichedDevices = await Future.wait(devices.map((device) async {
        final vendor = await _vendorApi.getVendor(device.macAddress);
        return device.copyWith(manufacturer: vendor ?? 'Desconhecido');
      }));
      return enrichedDevices;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> blockDevice(String macAddress) async {
    return await _dataSource.blockDevice(macAddress);
  }

  Future<bool> unblockDevice(String macAddress) async {
    return await _dataSource.unblockDevice(macAddress);
  }
}"