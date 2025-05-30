import 'package:flutter/material.dart';

import '../../../models/enum/message_type.dart';
import '../../../models/message_model.dart';

// Hiển thị từng bong bóng tin nhắn
class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    // Nếu có danh sách media, lấy phần tử đầu tiên (dùng cho ảnh, sticker, video thumbnail)
    final image = (message.mediaUrls?.isNotEmpty ?? false) ? message.mediaUrls!.first : null;

    // Định dạng giờ phút gửi tin nhắn
    final time = message.createdAt != null
        ? "${message.createdAt!.hour}:${message.createdAt!.minute.toString().padLeft(2, '0')}"
        : "";

    return Align(
      // Căn trái/phải tùy theo người gửi
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4), // Khoảng cách giữa các tin nhắn
        padding: const EdgeInsets.all(10), // Padding bên trong bong bóng
        decoration: BoxDecoration(
          color: isMe
              ? Colors.blue[50]
              : Colors.grey[200], // Màu nền khác nhau cho tin nhắn của mình/người khác
          borderRadius: BorderRadius.circular(12), // Bo tròn bong bóng
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start, // Căn nội dung theo hướng phù hợp
          children: [
            // Nếu là tin nhắn sticker và có ảnh → hiển thị ảnh
            if (message.type == MessageType.STICKER && image != null || message.type == MessageType.MEDIA && image != null)
              Image.network(image, height: 100),

            // Nếu là tin nhắn dạng text và có nội dung → hiển thị text
            if (message.type == MessageType.TEXT && message.content.isNotEmpty)
              Text(message.content, style: const TextStyle(fontSize: 15)),

            const SizedBox(height: 4), // Khoảng cách với thời gian gửi
            Text(
              time,
              style: const TextStyle(fontSize: 11, color: Colors.grey), // Thời gian gửi tin
            ),
          ],
        ),
      ),
    );
  }
}
