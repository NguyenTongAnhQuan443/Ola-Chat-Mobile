import 'package:flutter/material.dart';
import 'package:olachat_mobile/models/conversation_model.dart';
import 'package:olachat_mobile/services/conversation_service.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

class ListConversationViewModel extends ChangeNotifier {
  final ConversationService _service = ConversationService();
  List<ConversationModel> _conversations = [];
  bool _isLoading = true;

  List<ConversationModel> get conversations => _conversations;
  bool get isLoading => _isLoading;

  Future<void> fetchConversations() async {
    _isLoading = true;
    notifyListeners();
    print("${AppStyles.successIcon}[VM] Bắt đầu fetch conversations");

    try {
      _conversations = await _service.fetchConversations();
    } catch (e) {
      debugPrint("Error loading conversations: $e");
      _conversations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateConversationFromMessage(Map<String, dynamic> messageData) async {
    try {
      final String conversationId = messageData['conversationId'];
      final String content = messageData['content'];
      final String messageType = messageData['type'];
      final DateTime now = DateTime.now();

      final index = _conversations.indexWhere((c) => c.id == conversationId);

      if (index != -1) {
        final updated = _conversations[index];
        updated.lastMessage = messageType == 'TEXT' ? content : '[Media]';
        updated.updatedAt = now;
        _conversations.removeAt(index);
        _conversations.insert(0, updated);
      } else {
        // fetch mới
        final newConversation = await _service.fetchConversationById(conversationId);
        _conversations.insert(0, newConversation);
      }
      notifyListeners();
    } catch (e) {
      debugPrint(
          "${AppStyles.failureIcon}Update Conversation From Message Error: $e");
    }
  }
}
