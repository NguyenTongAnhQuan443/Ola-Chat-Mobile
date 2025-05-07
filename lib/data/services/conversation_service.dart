import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/config/api_config.dart';
import '../models/conversation_model.dart';

class ConversationService {
  static Future<List<ConversationModel>> fetchConversations(String token) async {
    final url = Uri.parse(ApiConfig.getConversations);

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> data = jsonBody['data'];
      return data.map((e) => ConversationModel.fromJson(e)).toList();
    } else {
      throw Exception('Không thể tải danh sách cuộc trò chuyện');
    }
  }
}
