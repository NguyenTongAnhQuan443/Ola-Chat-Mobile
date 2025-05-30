import 'package:flutter/material.dart';
import '../../models/message_model.dart';
import '../../services/socket_service.dart';
import '../../utils/app_styles.dart';
import '../models/enum/message_type.dart';

class MessageConversationViewModel extends ChangeNotifier {
  final SocketService _socketService = SocketService();

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

}
