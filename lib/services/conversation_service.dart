import 'package:dio/dio.dart';
import 'package:olachat_mobile/models/user_in_conversation_model.dart';
import 'package:olachat_mobile/services/dio_client.dart';
import 'package:olachat_mobile/services/token_service.dart';
import '../config/api_config.dart';

class ConversationService {
  Future<Map<String, UserInConversation>> getUsersInConversation(String conversationId) async {
    final token = await TokenService.getAccessToken();
    final dio = DioClient().dio;
    final url = ApiConfig.getUsersInConversation(conversationId);

    final response = await dio.get(
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
        for (var json in data)
          json['userId']: UserInConversation.fromJson(json)
      };
    } else {
      throw Exception("Lỗi khi fetch users in conversation: ${response.data}");
    }
  }
}
