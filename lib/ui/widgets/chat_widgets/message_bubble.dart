import 'package:flutter/material.dart';

import '../../../models/enum/message_type.dart';
import '../../../models/message_model.dart';

// Hiển thị từng tin nhắn
class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final image = (message.mediaUrls?.isNotEmpty ?? false)
        ? message.mediaUrls!.first
        : null;
    final time = message.createdAt != null
        ? "${message.createdAt!.hour}:${message.createdAt!.minute.toString().padLeft(2, '0')}"
        : "";

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[50] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.type == MessageType.STICKER && image != null)
              Image.network(image, height: 100),
            if (message.type == MessageType.TEXT && message.content.isNotEmpty)
              Text(message.content, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 4),
            Text(time,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
