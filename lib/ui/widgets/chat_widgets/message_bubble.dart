import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import '../../../models/enum/message_type.dart';
import '../../../models/message_model.dart';
import '../../../services/file_opener_service.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_filex/open_filex.dart';

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
            // ===== MEDIA (ẢNH, VIDEO, FILE, STICKER) =====
            if (message.type == MessageType.MEDIA || message.type == MessageType.FILE || message.type == MessageType.STICKER)
              ...mediaUrls.map((url) {
                final isImage = _isImageUrl(url);
                final isVideo = _isVideoUrl(url);

                return GestureDetector(
                  onTap: () => FileOpenerService.openMedia(context, url),
                  onLongPress: () => _downloadFile(context, url),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: isImage
                        ? Image.network(url, height: 200)
                        : _buildFileCard(url),
                  ),
                );
              }),

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

  // Card file
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

  // Show của sổ tải file
  void _showExternalAppPrompt(BuildContext context, String url) {
    final fileName = url.split('/').last;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Không thể xem trực tiếp", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Text("Bạn có muốn mở tệp \"$fileName\" bằng ứng dụng khác không?"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Huỷ"),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await FileOpenerService.openMedia(context, url);
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text("Mở bằng ứng dụng"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // Tải file nếu không mở được
  void _downloadFile(BuildContext context, String url) async {
    final fileName = url.split('/').last;
    final tempDir = await getTemporaryDirectory();
    final savePath = '${tempDir.path}/$fileName';

    try {
      await Dio().download(url, savePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Đã tải xuống: $fileName'),
          action: SnackBarAction(
            label: 'Mở',
            onPressed: () => OpenFilex.open(savePath),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Tải xuống thất bại')),
      );
    }
  }

}
