import 'dart:async';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/config/api_config.dart';

class PingService {
  static Timer? _pingTimer;

  /// Bắt đầu gửi ping mỗi 3 phút
  static void start() {
    print("🚀 PingService STARTED");
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      print("📡 Pinging...");
      _ping();
    });
    _ping();
  }

  /// Ngưng gửi ping
  static void stop() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  static Future<void> _ping() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    print("🧪 TOKEN: $token"); // Thêm log này để kiểm tra

    if (token == null) {
      print("⚠️ Không tìm thấy access_token, không gửi ping");
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
        print("✅ Ping thành công");
      } else {
        print("⚠️ Ping thất bại: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Ping exception: $e");
    }
  }
}
