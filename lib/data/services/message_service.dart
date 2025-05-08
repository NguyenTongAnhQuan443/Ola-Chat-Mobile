import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:olachat_mobile/core/utils/config/api_config.dart';
import 'package:olachat_mobile/data/models/message_model.dart';
import 'package:olachat_mobile/data/services/token_service.dart';

class MessageService {
  Future<List<MessageModel>> fetchMessagesByConversationId(String conversationId) async {
    final token = await TokenService.getAccessToken();
    final url = "${ApiConfig.base}/api/conversations/$conversationId/messages";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("📡 [fetchMessages] GET $url - Status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      final messages = data.map((e) => MessageModel.fromJson(e)).toList();
      print("✅ [fetchMessages] ${messages.length} messages fetched");
      return messages;
    } else {
      print("❌ [fetchMessages] Failed to fetch: ${response.body}");
      throw Exception('Failed to fetch messages');
    }
  }

}
