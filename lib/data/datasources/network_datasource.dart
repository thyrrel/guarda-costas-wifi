import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:guarda_costas_wifi/data/models/network_device_model.dart';

abstract class NetworkDataSource {
  Future<List<NetworkDeviceModel>> discoverDevices();
  Future<bool> blockDevice(String macAddress);
  Future<bool> unblockDevice(String macAddress);
}

class NetworkDataSourceImpl implements NetworkDataSource {
  final String _agentBaseUrl = 'http://127.0.0.1:8080';

  @override
  Future<List<NetworkDeviceModel>> discoverDevices() async {
    try {
      final response = await http.get(Uri.parse('$_agentBaseUrl/api/devices'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => NetworkDeviceModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao comunicar com o agente: ${response.statusCode}');
      }
    } catch (e) {
      print("Erro em discoverDevices (agente): $e");
      throw Exception('Não foi possível conectar ao agente. Verifique se ele está ativo.');
    }
  }

  @override
  Future<bool> blockDevice(String macAddress) async {
    try {
      final response = await http.post(
        Uri.parse('$_agentBaseUrl/api/block'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'macAddress': macAddress}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> unblockDevice(String macAddress) async {
    try {
      final response = await http.post(
        Uri.parse('$_agentBaseUrl/api/unblock'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'macAddress': macAddress}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}