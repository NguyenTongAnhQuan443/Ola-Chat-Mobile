import 'package:dio/dio.dart';
import 'package:olachat_mobile/models/message_model.dart';
import 'package:olachat_mobile/services/dio_client.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

class MessageService {
// Lấy instance Dio từ DioClient (có interceptor và token)
  final Dio _dio = DioClient().dio;

// Lấy danh sách tin nhắn theo conversationId (hỗ trợ phân trang)
  Future<List<MessageModel>> fetchMessages({
    required String conversationId,
    int page = 0,
    int size = 100,
    String sortDirection = 'desc', // Sắp xếp theo thời gian giảm dần (mới nhất trước)
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.getMessagesByConversation(conversationId),
        queryParameters: {
          'page': page,
          'size': size,
          'sortDirection': sortDirection, // Có thể là 'asc' hoặc 'desc'
        },
      );

      // Parse dữ liệu từ JSON sang danh sách MessageModel
      final List<dynamic> data = response.data;
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } catch (e) {
      print("${AppStyles.redPointIcon} [MessageService]Lỗi khi lấy danh sách tin nhắn: $e");
      rethrow;
    }
  }
}
