import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/config/api_config.dart';
import '../../data/models/conversation_model.dart';
import '../../data/services/token_service.dart';

class ConversationViewModel extends ChangeNotifier {
  List<ConversationModel> _conversations = [];
  bool _isLoading = true;

  List<ConversationModel> get conversations => _conversations;
  bool get isLoading => _isLoading;

  Future<void> fetchConversations() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await TokenService.getAccessToken();
      final currentUserId = await TokenService.getCurrentUserId();
      final url = Uri.parse(ApiConfig.getConversations);

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> list = data['data'];

        _conversations = [];

        for (var item in list) {
          final conversation = ConversationModel.fromJson(item);

          if (conversation.type == 'PRIVATE') {
            final userUrl = Uri.parse(
                '${ApiConfig.base}/api/conversations/${conversation.id}/users');
            final userResponse = await http.get(userUrl, headers: {
              'Authorization': 'Bearer $token',
            });

            if (userResponse.statusCode == 200) {
              final List<dynamic> users =
                  jsonDecode(utf8.decode(userResponse.bodyBytes));

              final otherUser = users.firstWhere(
                (u) => u['userId'] != currentUserId,
                orElse: () => null,
              );

              if (otherUser != null) {
                conversation.name = otherUser['displayName'] ?? 'Người dùng';
                conversation.avatarUrl = otherUser['avatar'] ?? '';
              }
            }
          }

          _conversations.add(conversation);
        }
      } else {
        throw Exception('Failed to load conversations');
      }
    } catch (e) {
      debugPrint("❌ Error loading conversations: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
