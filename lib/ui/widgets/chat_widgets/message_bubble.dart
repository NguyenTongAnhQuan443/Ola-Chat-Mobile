import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

import '../../../models/enum/message_type.dart';
import '../../../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final mediaUrls = message.mediaUrls ?? [];
    final time =
        message.createdAt != null ? "${message.createdAt!.hour}:${message.createdAt!.minute.toString().padLeft(2, '0')}" : "";

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // ===== ẢNH hoặc STICKER =====
            if (message.type == MessageType.STICKER || message.type == MessageType.MEDIA)
              ...mediaUrls.where((url) => _isImageUrl(url)).map(
                    (url) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Image.network(url, height: 200),
                    ),
                  ),

            // ===== FILE - KHÔNG PHẢI ẢNH =====
            if (message.type == MessageType.MEDIA || message.type == MessageType.FILE)
              ...mediaUrls.where((url) => !_isImageUrl(url)).map(
                (url) {
                  final fileName = url.split('/').last;
                  final extension = fileName.split('.').last.toLowerCase();
                  final icon = _getFileIcon(extension);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(icon, size: 28, color: Colors.deepPurple),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            fileName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

            // ===== TEXT =====
            if (message.type == MessageType.TEXT && message.content.isNotEmpty)
              Text(message.content, style: const TextStyle(fontSize: 15)),

            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Kiểm tra có phải ảnh hay không
  bool _isImageUrl(String url) {
    final mimeType = lookupMimeType(url);
    return mimeType != null && mimeType.startsWith('image/');
  }

  // Lấy icon file
  IconData _getFileIcon(String ext) {
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'zip':
      case 'rar':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }

}
