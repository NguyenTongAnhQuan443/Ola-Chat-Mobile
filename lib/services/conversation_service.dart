import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/services/dio_client.dart';
import 'package:olachat_mobile/services/token_service.dart';
import '../models/conversation_model.dart';

class ConversationService {
  final Dio _dio = DioClient().dio;

  // Lấy danh sách hội thoại
  Future<List<ConversationModel>> fetchConversations() async {
    final token = await TokenService.getAccessToken();
    final currentUserId = await TokenService.getCurrentUserId();

    final response = await _dio.get(ApiConfig.getConversations, options: Options(
        headers: {'Authorization': 'Bearer $token'}
    ));
    if (response.statusCode == 200 && response.data['data'] != null) {
      final List<dynamic> list = response.data['data'];
      List<ConversationModel> conversations = [];
      for (var item in list) {
        final conversation = ConversationModel.fromJson(item);

        // Gán tên & avatar cho PRIVATE
        if (conversation.type == 'PRIVATE') {
          final userResponse = await _dio.get(
              '${ApiConfig.base}/api/conversations/${conversation.id}/users',
              options: Options(headers: {'Authorization': 'Bearer $token'})
          );
          if (userResponse.statusCode == 200) {
            final users = userResponse.data as List;
            final otherUser = users.firstWhere(
                    (u) => u['userId'] != currentUserId, orElse: () => null);
            if (otherUser != null) {
              conversation.name = otherUser['displayName'] ?? 'Người dùng';
              conversation.avatarUrl = otherUser['avatar'] ?? '';
            }
          }
        }
        conversations.add(conversation);
      }
      return conversations;
    } else {
      throw Exception('Failed to load conversations');
    }
  }

  // Lấy 1 hội thoại mới khi có message mới
  Future<ConversationModel> fetchConversationById(String conversationId) async {
    final token = await TokenService.getAccessToken();
    final response = await _dio.get(
      '${ApiConfig.getConversations}/$conversationId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200 && response.data != null) {
      return ConversationModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load conversation');
    }
  }
}
