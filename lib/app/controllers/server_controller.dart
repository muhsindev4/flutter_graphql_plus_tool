import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import '../models/graphql_request_log.dart';
import 'log_controller.dart';

class ServerController extends GetxController {
  HttpServer? _wsServer;
  String? _socketUrl;
  String? get socketUrl => _socketUrl;
  final LogController _logController = Get.find();
  final int _port = 4040;
  bool _serverInitialized = false;
  bool get serverInitialized =>_serverInitialized;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Starts both WebSocket and HTTP servers.
  Future<void> initServer() async {
    if (_serverInitialized) return;
    try {
      final ip = await _getLocalIpAddress() ?? '0.0.0.0';

      _wsServer = await HttpServer.bind(ip, _port, shared: true);
      log('🛰️ WebSocket Server running at ws://$ip:$_port');

      _socketUrl = "$ip:$_port";
      _serverInitialized = true;
      _errorMessage = null;
      update();

      _wsServer!.listen(_handleUpgrade);
    } catch (e) {
      _serverInitialized = false;
      _errorMessage = "Failed to start server: $e";
      log("❌ $_errorMessage");
      update(); // Update UI
    }
  }


  /// Returns the first non-loopback IPv4 address, or null if none
  Future<String?> _getLocalIpAddress() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );
      for (var iface in interfaces) {
        for (var addr in iface.addresses) {
          return addr.address;
        }
      }
    } catch (_) {}
    return null;
  }

  /// Handles WebSocket upgrade
  void _handleUpgrade(HttpRequest request) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      WebSocketTransformer.upgrade(request).then(_handleWebSocket);
    } else {
      request.response
        ..statusCode = HttpStatus.forbidden
        ..write('WebSocket connections only')
        ..close();
    }
  }

  /// Handles WebSocket connections
  void _handleWebSocket(WebSocket socket) {
    log('🔗 Client connected: ${socket.hashCode}');
    socket.listen(
          (data) {
        log('📨 Received: $data');
        try {
          final log = GraphQLRequestLog.fromJson(jsonDecode(data));
          _logController.addLogs(log);
        } catch (e) {
          log('⚠️ Invalid JSON: $e');
        }
      },
      onDone: () => log('🔌 Client disconnected: ${socket.hashCode}'),
      onError: (error) => log('⚠️ WebSocket error: $error'),
    );
  }

  @override
  void onClose() {

    super.onClose();
    closeServer();
  }

  closeServer()
  {
    _wsServer?.close();
  }}
