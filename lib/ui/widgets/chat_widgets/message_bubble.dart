import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import '../../../models/enum/message_type.dart';
import '../../../models/message_model.dart';
import '../../../services/file_opener_service.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final mediaUrls = message.mediaUrls ?? [];
    final time = message.createdAt != null
        ? "${message.createdAt!.hour}:${message.createdAt!.minute.toString().padLeft(2, '0')}"
        : "";

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // ===== MEDIA (ẢNH, VIDEO, FILE, STICKER) =====
            if (message.type == MessageType.MEDIA ||
                message.type == MessageType.FILE ||
                message.type == MessageType.STICKER)
              ...mediaUrls.map((url) {
                final isImage = _isImageUrl(url);
                final isVideo = _isVideoUrl(url);

                return GestureDetector(
                  onTap: () => FileOpenerService.openMedia(context, url),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: isImage
                        ? Image.network(url, height: 200)
                        : _buildFileCard(url),
                  ),
                );
              }),

            // ===== TEXT =====
            if (message.type == MessageType.TEXT &&
                message.content.isNotEmpty)
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

  // Kiểm tra có phải ảnh không
  bool _isImageUrl(String url) {
    final mimeType = lookupMimeType(url);
    return mimeType != null && mimeType.startsWith('image/');
  }

  // Kiểm tra có phải video không
  bool _isVideoUrl(String url) {
    final mimeType = lookupMimeType(url);
    return mimeType != null && mimeType.startsWith('video/');
  }

  // Lấy icon dựa vào đuôi file
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
      case 'mp4':
      case 'mov':
        return Icons.videocam;
      default:
        return Icons.insert_drive_file;
    }
  }

  // Card file đẹp
  Widget _buildFileCard(String url) {
    final fileName = url.split('/').last;
    final ext = fileName.split('.').last.toLowerCase();
    final icon = _getFileIcon(ext);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              fileName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
