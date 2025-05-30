import 'dart:convert';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:olachat_mobile/view_models/list_conversation_view_model.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../../main.dart';

class SocketService {
  // Singleton: đảm bảo chỉ tạo một instance duy nhất trong toàn app
  static final SocketService _instance = SocketService._internal();

  // Factory constructor trả về instance sẵn có
  factory SocketService() => _instance;

  // Constructor private
  SocketService._internal();

  StompClient? _client; // Client dùng để kết nối WebSocket với STOMP
  String? _accessToken; // Token xác thực cho kết nối WebSocket

  // Hàm khởi tạo kết nối socket
  void init(String accessToken, {Function()? onConnectCallback}) {
    _accessToken = accessToken;

    final socketUrl = ApiConfig.socketUrl;

    _client = StompClient(
      config: StompConfig(
        url: socketUrl,
        onConnect: (frame) {
          print('${AppStyles.successIcon} Socket connected');
          if (onConnectCallback != null) onConnectCallback(); // Gọi callback khi kết nối xong
        },
        beforeConnect: () async {
          await Future.delayed(const Duration(milliseconds: 200)); // Delay nhẹ trước khi kết nối
        },
        onWebSocketError: (dynamic error) =>
            print('${AppStyles.successIcon}Socket Error: $error'), // Bắt lỗi kết nối

        // Header gửi kèm khi kết nối socket (quan trọng với bảo mật JWT)
        stompConnectHeaders: {
          'Authorization': 'Bearer $accessToken',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $accessToken',
        },

        heartbeatOutgoing: const Duration(seconds: 10), // Ping gửi đi
        heartbeatIncoming: const Duration(seconds: 10), // Ping nhận vào
        reconnectDelay: const Duration(seconds: 5), // Tự động reconnect nếu rớt mạng
      ),
    );

    _client!.activate(); // Bắt đầu kết nối
  }

  // Đăng ký lắng nghe một topic cụ thể từ server (dùng STOMP)
  void subscribe(String destination, Function(Map<String, dynamic>) callback) {
    _client?.subscribe(
      destination: destination, // Ví dụ: /user/{conversationId}/private
      callback: (frame) {
        final body = jsonDecode(frame.body!); // Parse JSON từ tin nhắn
        callback(body); // Gọi callback ngoài truyền dữ liệu

        onMessageReceived(body); // Gọi xử lý nội bộ (update UI)
      },
    );
  }

  // Gửi tin nhắn tới server qua socket (STOMP)
  void sendMessage(String destination, Map<String, dynamic> body) {
    _client?.send(
      destination: destination,
      body: jsonEncode(body), // Convert JSON trước khi gửi
    );
  }

  // Gọi khi nhận tin nhắn qua socket → cập nhật lại danh sách hội thoại
  void onMessageReceived(Map<String, dynamic> messageData) {
    print("${AppStyles.successIcon}[SOCKET] Gọi onMessageReceived");

    final context = navigatorKey.currentContext; // Lấy context từ toàn app

    if (context != null) {
      print("${AppStyles.successIcon}[SOCKET] Có context, chuẩn bị gọi fetchConversations");

      // Lấy ViewModel để cập nhật lại danh sách hội thoại
      final vm = Provider.of<ListConversationViewModel>(context, listen: false);
      vm.updateConversationFromMessage(messageData); // Chỉ update hội thoại liên quan
    } else {
      print("${AppStyles.failureIcon}[SOCKET] Không tìm thấy context để gọi fetchConversations");
    }
  }

  // Ngắt kết nối socket
  void disconnect() {
    _client?.deactivate();
    print('🔌 Socket disconnected');
  }

  // Kiểm tra socket có đang kết nối không
  bool get isConnected => _client?.connected ?? false;
}
