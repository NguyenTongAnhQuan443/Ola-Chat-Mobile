import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/config/api_config.dart';
import '../models/notification_model.dart';

class NotificationService {
  static Future<List<NotificationModel>> fetchNotifications({
    required String token,
    required int page,
    int size = 10,
    String sort = 'desc',
  }) async {
    final url = Uri.parse(ApiConfig.getNotifications(page: page, size: size, sort: sort));

    final response = await http.get(url, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> content = data['data']['content'];
      return content.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load notifications");
    }
  }
}
