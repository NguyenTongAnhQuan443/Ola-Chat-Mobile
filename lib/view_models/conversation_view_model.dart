import 'package:flutter/material.dart';
import '../services/conversation_service.dart';

class ConversationViewModel extends ChangeNotifier {
  final ConversationService _service = ConversationService();

  bool isDeleting = false;

  Future<bool> deleteConversation(String conversationId) async {
    isDeleting = true;
    notifyListeners();

    final result = await _service.deleteConversation(conversationId);

    isDeleting = false;
    notifyListeners();

    return result;
  }
}
