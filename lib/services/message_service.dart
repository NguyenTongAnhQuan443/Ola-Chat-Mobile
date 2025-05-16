import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/models/message_model.dart';
import 'package:olachat_mobile/services/token_service.dart';

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
      print("[FetchMessages TRUE] ${messages.length} messages fetched");
      return messages;
    } else {
      print("[FetchMessages FALSE] Failed to fetch: ${response.body}");
      throw Exception('Failed to fetch messages');
    }
  }

}
