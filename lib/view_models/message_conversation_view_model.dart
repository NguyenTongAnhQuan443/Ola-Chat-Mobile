import 'package:flutter/material.dart';
import '../../models/message_model.dart';
import '../../services/socket_service.dart';
import '../../utils/app_styles.dart';
import '../models/enum/message_type.dart';

class MessageConversationViewModel extends ChangeNotifier {
  final SocketService _socketService = SocketService();
  //
  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;

  // Gửi tin nhắn Text
  void sendTextMessage({
    required String content,
    required String conversationId,
    required String senderId,
  }) {
    if (content.trim().isEmpty) return;

    final now = DateTime.now().toIso8601String();

    final message = {
      "senderId": senderId,
      "conversationId": conversationId,
      "content": content,
      "type": MessageType.TEXT.name,
      "createdAt": now,
      "mediaUrls": [],
      "mentions": [],
      "recalled": false,
      "deletedStatus": [],
      "emojiTypes": [],
      "totalReactionCount": 0,
      "lastUserReaction": null
    };

    _socketService.sendMessage("/app/private-message", message);
    print("${AppStyles.successIcon} Đã gửi tin nhắn TEXT: $message");
  }

  // Gửi Sticker
  void sendStickerMessage({
    required String mediaUrl,
    required String conversationId,
    required String senderId,
  }) {
    final now = DateTime.now().toIso8601String();

    final message = {
      "senderId": senderId,
      "conversationId": conversationId,
      "content": "",
      "type": MessageType.STICKER.name,
      "createdAt": now,
      "mediaUrls": [mediaUrl],
      "mentions": [],
      "recalled": false,
      "deletedStatus": [],
      "emojiTypes": [],
      "totalReactionCount": 0,
      "lastUserReaction": null
    };

    _socketService.sendMessage("/app/private-message", message);
    print("${AppStyles.successIcon} Đã gửi STICKER: $message");
  }

  // Gửi file
  void sendFileMessage({
    required List<String> mediaUrls,
    required String conversationId,
    required String senderId,
    bool isImage = false,
  }) {
    final now = DateTime.now().toIso8601String();

    final message = {
      "senderId": senderId,
      "conversationId": conversationId,
      "content": "",
      "type": isImage ? MessageType.MEDIA.name : MessageType.FILE.name,
      "createdAt": now,
      "mediaUrls": mediaUrls,
      "mentions": [],
      "recalled": false,
      "deletedStatus": [],
      "emojiTypes": [],
      "totalReactionCount": 0,
      "lastUserReaction": null
    };

    _socketService.sendMessage("/app/private-message", message);
    print("${AppStyles.successIcon} Đã gửi FILE/MEDIA: $message");
  }

  // xóa tin nhắn
  void recallMessageInConversation(String messageId) {
    final index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(
        content: '[Tin nhắn đã được thu hồi]',
        type: MessageType.SYSTEM, // hoặc giữ nguyên type tuỳ bạn
      );
      notifyListeners();
    }
  }

  void handleRecallFromSocket(String messageId) {
    final index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(
        content: '[Tin nhắn đã được thu hồi]',
        type: MessageType.SYSTEM,
      );
      notifyListeners();
    }
  }

  // Gửi Audio
  void sendAudioMessage({
    required String audioUrl,
    required String conversationId,
    required String senderId,
  }) {
    final now = DateTime.now().toIso8601String();

    final message = {
      "senderId": senderId,
      "conversationId": conversationId,
      "content": "",
      "type": MessageType.VOICE.name,
      "createdAt": now,
      "mediaUrls": [audioUrl],
      "mentions": [],
      "recalled": false,
      "deletedStatus": [],
      "emojiTypes": [],
      "totalReactionCount": 0,
      "lastUserReaction": null
    };

    _socketService.sendMessage("/app/private-message", message);
  }

}
