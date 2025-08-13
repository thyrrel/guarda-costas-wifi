"import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http_server/http_server.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package.dart';

class SimulatedAgentService {
  HttpServer? _server;
  final List<WebSocketChannel> _clients = [];
  final StreamController<String> _logStreamController = StreamController.broadcast();
  Stream<String> get logStream => _logStreamController.stream;

  Timer? _bandwidthTimer;
  final List<Map<String, dynamic>> _devices = [];

  SimulatedAgentService() {
    _initializeDevices();
  }

  void _log(String message) {
    final timestamp = DateFormat('HH:mm:ss').format(DateTime.now());
    _logStreamController.add('[\$timestamp] \$message');
  }

  void _initializeDevices() {
    _devices.addAll([
      {'ipAddress': '192.168.1.1', 'macAddress': '00:1A:2B:3C:4D:5E', 'hostname': 'Roteador Principal', 'isBlocked': false},
      {'ipAddress': '192.168.1.101', 'macAddress': 'AA:BB:CC:DD:EE:FF', 'hostname': 'iPhone de João', 'isBlocked': false},
      {'ipAddress': '192.168.1.102', 'macAddress': '11:22:33:44:55:66', 'hostname': 'SmartTV da Sala', 'isBlocked': false},
      {'ipAddress': '192.168.1.103', 'macAddress': 'A1:B2:C3:D4:E5:F6', 'hostname': 'Notebook-Trabalho', 'isBlocked': true},
    ]);
  }

  Future<void> start() async {
    if (_server != null) {
      _log('Agente já está em execução.');
      return;
    }
    try {
      var handler = const Pipeline()
          .addMiddleware(logRequests())
          .addHandler(_handleRequest);

      _server = await io.serve(handler, '127.0.0.1', 8080);
      _log('Agente iniciado em http://\${_server!.address.host}:\${_server!.port}');
      
      _bandwidthTimer = Timer.periodic(const Duration(seconds: 2), (_) => _simulateBandwidthUsage());
    } catch (e) {
      _log('Erro ao iniciar o agente: \$e');
    }
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _bandwidthTimer?.cancel();
    _clients.clear();
    _server = null;
    _log('Agente parado.');
  }

  void dispose() {
    _logStreamController.close();
    stop();
  }

  Handler _handleRequest(Request request) {
    if (request.url.path == 'ws') {
      return webSocketHandler((WebSocketChannel client) {
        _log('Novo cliente conectado ao WebSocket.');
        _clients.add(client);
        client.stream.listen((message) {
          _log('Mensagem recebida do cliente: \$message');
        }, onDone: () {
          _log('Cliente desconectado.');
          _clients.remove(client);
        });
      });
    }
    if (request.url.path == 'api/devices' && request.method == 'GET') {
      return Response.ok(jsonEncode(_devices), headers: {'Content-Type': 'application/json'});
    }
    if (request.url.path == 'api/block' && request.method == 'POST') {
      return (Request innerRequest) async {
        final body = await innerRequest.readAsString();
        final mac = jsonDecode(body)['macAddress'];
        _updateDeviceBlockStatus(mac, true);
        _broadcastUpdate('device_updated', {'macAddress': mac, 'isBlocked': true});
        return Response.ok('Dispositivo bloqueado');
      };
    }
    if (request.url.path == 'api/unblock' && request.method == 'POST') {
      return (Request innerRequest) async {
        final body = await innerRequest.readAsString();
        final mac = jsonDecode(body)['macAddress'];
        _updateDeviceBlockStatus(mac, false);
        _broadcastUpdate('device_updated', {'macAddress': mac, 'isBlocked': false});
        return Response.ok('Dispositivo desbloqueado');
      };
    }
    return Response.notFound('Endpoint não encontrado.');
  }

  void _updateDeviceBlockStatus(String mac, bool isBlocked) {
    final index = _devices.indexWhere((d) => d['macAddress'] == mac);
    if (index != -1) {
      _devices[index]['isBlocked'] = isBlocked;
      _log('Status de bloqueio atualizado para \$mac: \$isBlocked');
    }
  }

  void _broadcastUpdate(String type, dynamic data) {
    final message = jsonEncode({'type': type, 'payload': data});
    _log('Transmitindo atualização: \$type');
    for (var client in _clients) {
      client.sink.add(message);
    }
  }

  void simulateNewDevice() {
    final randomMac = List.generate(6, (_) => Random().nextInt(256).toRadixString(16).padLeft(2, '0')).join(':').toUpperCase();
    final newDevice = {
      'ipAddress': '192.168.1.\${110 + Random().nextInt(50)}',
      'macAddress': randomMac,
      'hostname': 'Dispositivo Aleatório',
      'isBlocked': false
    };
    _devices.add(newDevice);
    _log('EVENTO: Novo dispositivo simulado adicionado: \$randomMac');
    _broadcastUpdate('device_added', newDevice);
  }
  
  void _simulateBandwidthUsage() {
    if (_clients.isEmpty) return;

    final usageData = _devices.map((device) {
      final download = Random().nextDouble() * (device['hostname']!.contains('TV') ? 50 : 5);
      final upload = Random().nextDouble() * 2;
      return {
        'macAddress': device['macAddress'],
        'download_mbps': download,
        'upload_mbps': upload,
      };
    }).toList();

    _broadcastUpdate('bandwidth_update', usageData);
  }
}"