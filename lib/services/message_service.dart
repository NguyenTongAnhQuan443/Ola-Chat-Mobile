import 'package:dio/dio.dart';
import 'package:olachat_mobile/models/message_model.dart';
import 'package:olachat_mobile/services/dio_client.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

class MessageService {
  final Dio _dio = DioClient().dio;

  /// Fetch danh sách tin nhắn theo conversationId (hỗ trợ phân trang)
  Future<List<MessageModel>> fetchMessages({
    required String conversationId,
    int page = 0,
    int size = 100,
    String sortDirection = 'desc',
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.getMessagesByConversation(conversationId),
        queryParameters: {
          'page': page,
          'size': size,
          'sortDirection': sortDirection,
        },
      );

      final List<dynamic> data = response.data;
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } catch (e) {
      print("${AppStyles.redPointIcon} Lỗi khi lấy danh sách tin nhắn: $e");
      rethrow;
    }
  }
}
