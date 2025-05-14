import 'dart:async';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/config/api_config.dart';
import '../../core/utils/constants.dart';

class PingService {
  static Timer? _pingTimer;

  /// Bắt đầu gửi ping mỗi 5 phút
  static void start() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _ping();
    });
    _ping(); // Ping ngay lập tức khi start
  }

  /// Ngưng gửi ping
  static void stop() {
    _pingTimer?.cancel();
    _pingTimer = null;
    print("${AppStyles.warningIcon}[PING STOPPED] Đã ngừng gửi ping.");
  }

  static Future<void> _ping() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    print("${AppStyles.warningIcon}[TOKEN PING]: $token");

    if (token == null) {
      print("${AppStyles.failureIcon}[PING ERROR] Không tìm thấy access_token, không gửi ping.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.ping),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("${AppStyles.successIcon}[PING SUCCESS] Ping thành công.");
      } else {
        print("${AppStyles.failureIcon}[PING FAILED] Mã trạng thái: ${response.statusCode}");
      }
    } catch (e) {
      print("${AppStyles.failureIcon}[PING EXCEPTION] Lỗi khi gửi ping: $e");
    }
  }
}
