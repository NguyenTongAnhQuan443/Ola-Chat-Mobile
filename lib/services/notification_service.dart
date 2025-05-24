import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';
import '../models/notification_model.dart';
import 'token_service.dart';

class NotificationService {
  static final Dio _dio = Dio();

  static Future<List<NotificationModel>> fetchNotifications({
    required int page,
    int size = 10,
    String sort = 'desc',
  }) async {
    final token = await TokenService.getAccessToken();
    if (token == null) throw Exception("Token không tồn tại");

    final url = ApiConfig.getNotifications(page: page, size: size, sort: sort);

    final response = await _dio.get(
      url,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final List<dynamic> content = data['data']['content'];
      return content.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load notifications");
    }
  }
}
