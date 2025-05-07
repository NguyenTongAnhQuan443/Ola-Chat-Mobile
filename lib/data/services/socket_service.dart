import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../core/utils/config/api_config.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  SocketService._internal();

  StompClient? _client;
  String? _accessToken;

  void init(String accessToken) {
    _accessToken = accessToken;

    final socketUrl = ApiConfig.socketUrl;
    print("🌐 socketUrl used: $socketUrl");

    _client = StompClient(
      config: StompConfig(
        url: socketUrl,
        onConnect: _onConnect,
        beforeConnect: () async {
          print('📡 Connecting socket...');
          await Future.delayed(const Duration(milliseconds: 200));
        },
        onWebSocketError: (dynamic error) => print('❌ Socket Error: $error'),
        stompConnectHeaders: {
          'Authorization': 'Bearer $accessToken',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $accessToken',
        },
        heartbeatOutgoing: const Duration(seconds: 10),
        heartbeatIncoming: const Duration(seconds: 10),
        reconnectDelay: const Duration(seconds: 5),
      ),
    );

    _client!.activate();
  }

  void _onConnect(StompFrame frame) {
    print('✅ Socket connected');
  }

  void subscribe(String destination, Function(Map<String, dynamic>) callback) {
    _client?.subscribe(
      destination: destination,
      callback: (frame) {
        final body = jsonDecode(frame.body!);
        callback(body);
      },
    );
  }

  void sendMessage(String destination, Map<String, dynamic> body) {
    _client?.send(
      destination: destination,
      body: jsonEncode(body),
    );
  }

  void disconnect() {
    _client?.deactivate();
    print('🔌 Socket disconnected');
  }

  bool get isConnected => _client?.connected ?? false;
}
