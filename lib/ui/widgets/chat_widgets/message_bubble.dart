import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import '../../../models/enum/message_type.dart';
import '../../../models/message_model.dart';
import '../../../services/file_opener_service.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

import '../../../services/socket_service.dart';
import '../../views/video_player_screen.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final String myAvatar;
  final String currentUserAvatar;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.myAvatar,
    required this.currentUserAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final mediaUrls = message.mediaUrls ?? [];
    final time =
        message.createdAt != null ? "${message.createdAt!.hour}:${message.createdAt!.minute.toString().padLeft(2, '0')}" : "";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar đối phương
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: (currentUserAvatar.isNotEmpty)
                    ? NetworkImage(currentUserAvatar)
                    : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
              ),
            ),

          // Tin nhắn
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue[50] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      // MEDIA (ẢNH, VIDEO, FILE, STICKER)
                      if (message.type == MessageType.MEDIA ||
                          message.type == MessageType.FILE ||
                          message.type == MessageType.STICKER)
                        ...mediaUrls.map((url) {
                          final isImage = _isImageUrl(url);
                          return GestureDetector(
                            onTap: () => FileOpenerService.openMedia(context, url),
                            onLongPress: isMe ? () => _showRecallOptions(context, message) : null,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: isImage ? Image.network(url, height: 200) : _buildFileCard(url),
                            ),
                          );
                        }),

                      // TEXT
                      if (message.content == '[Tin nhắn đã được thu hồi]')
                        Text(
                          message.content,
                          style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                      if (message.type == MessageType.TEXT && message.content.isNotEmpty)
                        GestureDetector(
                          onLongPress: isMe ? () => _showRecallOptions(context, message) : null,
                          child: Text(message.content, style: const TextStyle(fontSize: 15)),
                        ),

                      // VOICE
                      if (message.type == MessageType.VOICE && mediaUrls.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.play_circle_fill),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoPlayerScreen(videoUrl: mediaUrls.first),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Avatar của bạn
          if (isMe)
            Padding(
                padding: const EdgeInsets.only(left: 8),
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: (myAvatar.isNotEmpty)
                      ? NetworkImage(myAvatar)
                      : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                ))
        ],
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
          content: Text('${AppStyles.successIcon} Đã tải xuống: $fileName'),
          action: SnackBarAction(
            label: 'Mở',
            onPressed: () => OpenFilex.open(savePath),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('${AppStyles.failureIcon} Tải xuống thất bại')),
      );
    }
  }

  // Xử lý thu hồi tin nhắn
  void _showRecallOptions(BuildContext context, MessageModel message) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.undo),
                title: const Text('Thu hồi tin nhắn'),
                onTap: () {
                  Navigator.pop(context);
                  _recallMessage(context, message);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Huỷ'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _recallMessage(BuildContext context, MessageModel message) {
    // Gọi SocketService để gửi dữ liệu thu hồi
    SocketService().recallMessage(message.id.toString(), message.senderId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã gửi thu hồi tin nhắn')),
    );
  }
}
