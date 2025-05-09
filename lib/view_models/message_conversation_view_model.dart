import 'dart:convert';

import 'package:flutter/material.dart';
import '../data/enum/message_type.dart';
import '../data/models/message_model.dart';
import '../data/services/message_service.dart';
import '../data/services/socket_service.dart';
import '../data/services/token_service.dart';
class MessageConversationViewModel extends ChangeNotifier {
  final MessageService _messageService = MessageService();
  final SocketService _socketService = SocketService();

  List<MessageModel> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentUserId;

  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> init(String conversationId) async {
    _isLoading = true;
    notifyListeners();

    final userInfo = await TokenService.getUserInfo();
    if (userInfo != null) {
      _currentUserId = jsonDecode(userInfo)['userId'];
    }

    try {
      _messages = await _messageService.fetchMessagesByConversationId(conversationId);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendTextMessage(String conversationId, String content) async {
    if (content.trim().isEmpty || _currentUserId == null) return;

    final msg = {
      'senderId': _currentUserId,
      'conversationId': conversationId,
      'content': content.trim(),
      'type': MessageType.TEXT.name,
    };

    _socketService.sendMessage('/app/private-message', msg);
  }

  Future<void> sendSticker(String conversationId, String stickerUrl) async {
    if (_currentUserId == null) return;

    final msg = {
      'senderId': _currentUserId,
      'conversationId': conversationId,
      'content': stickerUrl,
      'type': MessageType.STICKER.name,
    };

    _socketService.sendMessage('/app/private-message', msg);
  }

  void disposeSocket() {
    _socketService.disconnect();
  }
}
