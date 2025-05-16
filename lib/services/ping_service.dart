import 'dart:async';
import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/services/dio_client.dart';
import 'package:olachat_mobile/services/token_service.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

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
    final token = await TokenService.getAccessToken();
    print("${AppStyles.greenPointIcon}[PING] Token hiện tại: $token");

    if (token == null) {
      print("${AppStyles.failureIcon}Token null. Không gửi ping.");
      return;
    }

    try {
      final response = await DioClient().dio.get(ApiConfig.ping);
      print("${AppStyles.greenPointIcon}PING STATUS: ${response.statusCode}");
    } catch (e) {
      if (e is DioException) {
        print("${AppStyles.failureIcon}[DIO ERROR] - Type: ${e.type}");
        print("${AppStyles.failureIcon}[DIO ERROR] - Message: ${e.message}");
        print("${AppStyles.failureIcon}[DIO ERROR] - Response: ${e.response}");
        print(
            "${AppStyles.failureIcon}[DIO ERROR] - Request URI: ${e.requestOptions.uri}");
      } else {
        print(
            "${AppStyles.failureIcon}[PING ERROR] Không phải DioException: $e");
      }
    }
  }
}
