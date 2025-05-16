import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/models/conversation_model.dart';
import 'package:olachat_mobile/services/token_service.dart';

class ListConversationViewModel extends ChangeNotifier {
  List<ConversationModel> _conversations = [];
  bool _isLoading = true;

  List<ConversationModel> get conversations => _conversations;
  bool get isLoading => _isLoading;

  Future<void> fetchConversations() async {
    _isLoading = true;
    notifyListeners();
    print("[VM] Bắt đầu fetch conversations");

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
      }
      else {
        throw Exception('Failed to load conversations');
      }
      print("[VM] Fetch thành công ${_conversations.length} cuộc trò chuyện");

    } catch (e) {
      debugPrint("Error loading conversations: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//   Fetch lại conversation đó
  void updateConversationFromMessage(Map<String, dynamic> messageData) async {
    try {
      final String conversationId = messageData['conversationId'];
      final String content = messageData['content'];
      final String messageType = messageData['type']; // TEXT, MEDIA...
      final DateTime now = DateTime.now();

      // Tìm xem đã có cuộc trò chuyện này chưa
      final index = _conversations.indexWhere((c) => c.id == conversationId);

      if (index != -1) {
        // Cập nhật cuộc trò chuyện hiện có
        final updated = _conversations[index];
        updated.lastMessage = messageType == 'TEXT' ? content : '[Media]';
        updated.updatedAt = now;

        // Đưa lên đầu danh sách
        _conversations.removeAt(index);
        _conversations.insert(0, updated);
      } else {
        // Nếu chưa có (ví dụ vừa tạo), gọi API để lấy 1 conversation mới
        final token = await TokenService.getAccessToken();
        final res = await http.get(
          Uri.parse('${ApiConfig.base}/api/conversations/$conversationId'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (res.statusCode == 200) {
          final data = jsonDecode(utf8.decode(res.bodyBytes));
          final newConversation = ConversationModel.fromJson(data);

          _conversations.insert(0, newConversation);
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint("updateConversationFromMessage error: $e");
    }
  }

}
