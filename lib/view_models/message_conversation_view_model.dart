import 'package:flutter/material.dart';
import '../data/models/message_model.dart';
import '../data/services/message_service.dart';

class MessageConversationViewModel extends ChangeNotifier {
  final MessageService _messageService = MessageService();

  List<MessageModel> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadMessages(String conversationId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _messages = await _messageService.fetchMessagesByConversationId(conversationId);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void addMessage(MessageModel message) {
    _messages.add(message);
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
