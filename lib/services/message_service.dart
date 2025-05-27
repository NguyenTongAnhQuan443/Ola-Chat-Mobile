import 'package:dio/dio.dart';
import 'package:olachat_mobile/models/message_model.dart';
import 'package:olachat_mobile/services/dio_client.dart';
import 'package:olachat_mobile/services/token_service.dart';
import '../config/api_config.dart';

class MessageService {
  Future<List<MessageModel>> fetchMessagesByConversationId(
      String conversationId, {
        int page = 0,
        int size = 20,
        String sortDirection = 'desc',
      }) async {
    final token = await TokenService.getAccessToken();
    final dio = DioClient().dio;
    final url =
        "${ApiConfig.base}/api/conversations/$conversationId/messages?page=$page&size=$size&sortDirection=$sortDirection";

    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      // Nếu backend trả List
      if (response.data is List) {
        return (response.data as List)
            .map((e) => MessageModel.fromJson(e))
            .toList();
      }
      // Nếu backend trả dạng {data: List, ...}
      if (response.data is Map &&
          response.data['data'] != null &&
          response.data['data'] is List) {
        return (response.data['data'] as List)
            .map((e) => MessageModel.fromJson(e))
            .toList();
      }
      throw Exception('Không nhận được dữ liệu tin nhắn.');
    } else {
      throw Exception('Failed to fetch messages: ${response.data}');
    }
  }
}
