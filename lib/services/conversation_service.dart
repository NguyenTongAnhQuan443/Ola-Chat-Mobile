import 'package:dio/dio.dart';
import 'package:olachat_mobile/models/user_in_conversation_model.dart';
import 'package:olachat_mobile/services/dio_client.dart';
import 'package:olachat_mobile/services/token_service.dart';
import '../config/api_config.dart';

class ConversationService {
  final Dio _dio = DioClient().dio;

  /// Lấy danh sách người dùng trong cuộc trò chuyện
  Future<Map<String, UserInConversation>> getUsersInConversation(String conversationId) async {
    final token = await TokenService.getAccessToken();
    final url = ApiConfig.getUsersInConversation(conversationId);

    final response = await _dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data is List
          ? response.data
          : (response.data['data'] ?? []);
      return {
        for (var json in data) json['userId']: UserInConversation.fromJson(json),
      };
    } else {
      throw Exception("Lỗi khi fetch users in conversation: ${response.data}");
    }
  }

  /// Xoá cuộc trò chuyện theo ID
  Future<bool> deleteConversation(String conversationId) async {
    try {
      final token = await TokenService.getAccessToken();
      final url = ApiConfig.deleteConversation(conversationId);

      final response = await _dio.delete(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Lỗi khi xoá cuộc trò chuyện: $e");
    }
  }
}
