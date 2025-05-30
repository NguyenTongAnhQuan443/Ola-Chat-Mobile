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

    print("${AppStyles.connectIcon} Đang khởi tạo kết nối STOMP tới: $socketUrl");

    _client = StompClient(
      config: StompConfig(
        url: socketUrl,
        onConnect: (frame) {
          print('${AppStyles.successIcon} [SOCKET] Kết nối STOMP thành công ${AppStyles.successIcon}');
          if (onConnectCallback != null) onConnectCallback();
        },
        beforeConnect: () async {
          print("${AppStyles.warningIcon} [SOCKET] Đang chờ kết nối...");
          await Future.delayed(const Duration(milliseconds: 200));
        },
        onWebSocketError: (dynamic error) {
          print('${AppStyles.failureIcon}[SOCKET] Lỗi kết nối WebSocket: $error');
        },
        onDisconnect: (frame) {
          print('${AppStyles.connectIcon} [SOCKET] Đã ngắt kết nối');
        },
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
    print("${AppStyles.greenPointIcon} [SOCKET] Đang đăng ký lắng nghe: $destination");

    _client?.subscribe(
      destination: destination,
      callback: (frame) {
        if (frame.body == null) {
          print("${AppStyles.warningIcon} [SOCKET] Tin nhắn rỗng từ: $destination");
          return;
        }

        print("${AppStyles.receiveIcon} [SOCKET] Đã nhận tin nhắn từ $destination: ${frame.body}");

        final body = jsonDecode(frame.body!);
        callback(body);
        onMessageReceived(body);
      },
    );
  }

  void sendMessage(String destination, Map<String, dynamic> body) {
    final encoded = jsonEncode(body);
    print("${AppStyles.receiveIcon} [SOCKET] Gửi tin nhắn tới $destination: $encoded");

    _client?.send(
      destination: destination,
      body: encoded,
    );
  }

  void onMessageReceived(Map<String, dynamic> messageData) {
    print("${AppStyles.successIcon} [SOCKET] Đã nhận và xử lý tin nhắn");

    final context = navigatorKey.currentContext;

    if (context != null) {
      final vm = Provider.of<ListConversationViewModel>(context, listen: false);
      vm.updateConversationFromMessage(messageData);
    } else {
      print("${AppStyles.failureIcon} [SOCKET] Không tìm thấy context để cập nhật hội thoại");
    }
  }

  void disconnect() {
    _client?.deactivate();
    print('${AppStyles.connectIcon} [SOCKET] Ngắt kết nối thành công');
  }

  bool get isConnected => _client?.connected ?? false;
}
