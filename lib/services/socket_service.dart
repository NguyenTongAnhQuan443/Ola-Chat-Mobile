import 'dart:convert';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:olachat_mobile/view_models/list_conversation_view_model.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../../main.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal();

  StompClient? _client;
  String? _accessToken;

  void init(String accessToken, {Function()? onConnectCallback}) {
    _accessToken = accessToken;

    final socketUrl = ApiConfig.socketUrl;

    _client = StompClient(
      config: StompConfig(
        url: socketUrl,
        onConnect: (frame) {
          print('${AppStyles.successIcon} Socket connected');
          if (onConnectCallback != null) onConnectCallback();
        },
        beforeConnect: () async {
          await Future.delayed(const Duration(milliseconds: 200));
        },
        onWebSocketError: (dynamic error) =>
            print('${AppStyles.successIcon}Socket Error: $error'),
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

  void subscribe(String destination, Function(Map<String, dynamic>) callback) {
    _client?.subscribe(
      destination: destination,
      callback: (frame) {
        final body = jsonDecode(frame.body!);
        callback(body);

        onMessageReceived(body);
      },
    );
  }

  void sendMessage(String destination, Map<String, dynamic> body) {
    _client?.send(
      destination: destination,
      body: jsonEncode(body),
    );
  }

  // Fetch conversation khi có tin nhắn mới
  void onMessageReceived(Map<String, dynamic> messageData) {
    print("${AppStyles.successIcon}[SOCKET] Gọi onMessageReceived");

    final context = navigatorKey.currentContext;
    if (context != null) {
      print(
          "${AppStyles.successIcon}[SOCKET] Có context, chuẩn bị gọi fetchConversations");

      // final vm = Provider.of<ListConversationViewModel>(context, listen: false);
      // vm.fetchConversations();
      final vm = Provider.of<ListConversationViewModel>(context, listen: false);
      vm.updateConversationFromMessage(messageData); // không fetch toàn bộ
    } else {
      print(
          "${AppStyles.failureIcon}[SOCKET] Không tìm thấy context để gọi fetchConversations");
    }
  }

  void disconnect() {
    _client?.deactivate();
    print('🔌 Socket disconnected');
  }

  bool get isConnected => _client?.connected ?? false;
}
