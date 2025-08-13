import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:guarda_costas_wifi/data/models/network_device_model.dart';
import 'package:guarda_costas_wifi/data/repositories/network_repository.dart';
import 'package:guarda_costas_wifi/core/services/database_service.dart';
import 'package:guarda_costas_wifi/core/services/device_health_service.dart';
import 'package:guarda_costas_wifi/core/services/ip_analysis_service.dart';
import 'package:port_scanner/port_scanner.dart';

class HomeProvider extends ChangeNotifier {
  final NetworkRepository _repository = NetworkRepository();
  final DatabaseService _dbService = DatabaseService.instance;
  final DeviceHealthService _healthService = DeviceHealthService();
  final IpAnalysisService _ipAnalysisService = IpAnalysisService();

  List<NetworkDeviceModel> _devices = [];
  bool _isLoading = false;
  String? _userMessage;
  bool _isErrorMessage = false;

  WebSocketChannel? _channel;
  bool _isAgentConnected = false;
  bool _isAnalyzingHealth = false;
  HealthAnalysisResult? _healthResult;

  List<NetworkDeviceModel> get devices => _devices;
  bool get isLoading => _isLoading;
  bool get isAgentConnected => _isAgentConnected;
  bool get isAnalyzingHealth => _isAnalyzingHealth;
  HealthAnalysisResult? get healthResult => _healthResult;

  (String, bool)? get message {
    if (_userMessage != null) return (_userMessage!, _isErrorMessage);
    return null;
  }

  void clearMessage() => _userMessage = null;

  Future<void> fetchDevices() async {
    _isLoading = true;
    notifyListeners();
    try {
      final discoveredDevices = await _repository.getDiscoveredDevices();
      for (var device in discoveredDevices) {
        final storedDevice = await _dbService.getDevice(device.macAddress);
        
        final enrichedDevice = device.copyWith(
          name: storedDevice?.name ?? device.name,
          isFavorite: storedDevice?.isFavorite ?? false,
          firstSeen: storedDevice?.firstSeen ?? device.firstSeen,
        );
        
        await _dbService.upsertDevice(enrichedDevice);
        
        final index = _devices.indexWhere((d) => d.macAddress == enrichedDevice.macAddress);
        if (index != -1) {
          _devices[index] = enrichedDevice;
        } else {
          _devices.add(enrichedDevice);
        }
      }
      _userMessage = "Lista de dispositivos atualizada.";
      _isErrorMessage = false;
    } catch (e) {
      _userMessage = e.toString();
      _isErrorMessage = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> blockDevice(String macAddress) async {
    final success = await _repository.blockDevice(macAddress);
    if (success) {
      final index = _devices.indexWhere((d) => d.macAddress == macAddress);
      if (index != -1) {
        _devices[index] = _devices[index].copyWith(isBlocked: true);
        _userMessage = "Dispositivo bloqueado com sucesso!";
        _isErrorMessage = false;
      }
    } else {
      _userMessage = "Falha ao bloquear dispositivo.";
      _isErrorMessage = true;
    }
    notifyListeners();
  }

  Future<void> unblockDevice(String macAddress) async {
    final success = await _repository.unblockDevice(macAddress);
    if (success) {
      final index = _devices.indexWhere((d) => d.macAddress == macAddress);
      if (index != -1) {
        _devices[index] = _devices[index].copyWith(isBlocked: false);
        _userMessage = "Dispositivo desbloqueado com sucesso!";
        _isErrorMessage = false;
      }
    } else {
      _userMessage = "Falha ao desbloquear dispositivo.";
      _isErrorMessage = true;
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(String macAddress) async {
    final index = _devices.indexWhere((d) => d.macAddress == macAddress);
    if (index != -1) {
      final device = _devices[index];
      final updatedDevice = device.copyWith(isFavorite: !device.isFavorite);
      _devices[index] = updatedDevice;
      await _dbService.upsertDevice(updatedDevice);
      notifyListeners();
    }
  }

  Future<void> analyzeDeviceHealth(NetworkDeviceModel device) async {
    _isAnalyzingHealth = true;
    _healthResult = null;
    notifyListeners();

    final ports = [21, 22, 23, 80, 443, 3389, 8080];
    final openPortsResult = await PortScanner.discover(device.ipAddress, ports: ports);
    final openPortsMap = {for (var p in ports) p: openPortsResult.contains(p)};
    
    final ipAbuseScore = await _ipAnalysisService.getIpAbuseScore(device.ipAddress);

    _healthResult = _healthService.analyzeDevice(
      device: device,
      openPorts: openPortsMap,
      ipAbuseScore: ipAbuseScore,
    );

    _isAnalyzingHealth = false;
    notifyListeners();
  }

  void connectToAgent() {
    if (_isAgentConnected) return;
    try {
      _channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:8080/ws'));
      _isAgentConnected = true;
      _userMessage = "Sincronização com o roteador ativa!";
      _isErrorMessage = false;
      notifyListeners();

      _channel!.stream.listen(
        (message) {
          _handleAgentUpdate(jsonDecode(message));
        },
        onDone: () {
          _isAgentConnected = false;
          _userMessage = "Sincronização com o roteador perdida.";
          _isErrorMessage = true;
          notifyListeners();
        },
        onError: (error) {
          _isAgentConnected = false;
          _userMessage = "Erro na sincronização: $error";
          _isErrorMessage = true;
          notifyListeners();
        },
      );
    } catch (e) {
      _isAgentConnected = false;
      _userMessage = "Não foi possível conectar ao agente.";
      _isErrorMessage = true;
      notifyListeners();
    }
  }

  void disconnectFromAgent() {
    _channel?.sink.close();
    _isAgentConnected = false;
    notifyListeners();
  }

  void _handleAgentUpdate(Map<String, dynamic> update) {
    final type = update['type'];
    final payload = update['payload'];

    switch (type) {
      case 'device_updated':
        final index = _devices.indexWhere((d) => d.macAddress == payload['macAddress']);
        if (index != -1) {
          _devices[index] = _devices[index].copyWith(isBlocked: payload['isBlocked']);
          _userMessage = "Estado do dispositivo ${payload['macAddress']} atualizado em tempo real.";
          _isErrorMessage = false;
          notifyListeners();
        }
        break;
      case 'device_added':
        final newDevice = NetworkDeviceModel.fromJson(payload);
        _devices.removeWhere((d) => d.macAddress == newDevice.macAddress);
        _devices.add(newDevice);
        _userMessage = "Novo dispositivo detectado na rede!";
        _isErrorMessage = false;
        _dbService.addEvent(
          'device_connected',
          "Novo dispositivo '${payload['hostname']}' (${payload['macAddress']}) conectou-se à rede.",
          macAddress: payload['macAddress'],
        );
        notifyListeners();
        break;
    }
  }
}