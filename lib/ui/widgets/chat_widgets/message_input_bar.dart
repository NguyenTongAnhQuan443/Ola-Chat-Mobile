import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:provider/provider.dart';
import '../../../services/file_upload_service.dart';
import '../../../view_models/message_conversation_view_model.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class MessageInputBar extends StatefulWidget {
  final String conversationId;
  final String currentUserId;

  const MessageInputBar({
    super.key,
    required this.conversationId,
    required this.currentUserId,
  });

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final TextEditingController _controller = TextEditingController();

  // Xử lý gửi tin nhắn
  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    Provider.of<MessageConversationViewModel>(context, listen: false).sendTextMessage(
      content: text,
      conversationId: widget.conversationId,
      senderId: widget.currentUserId,
    );

    _controller.clear();
  }

  // Gửi sticker/GIF
  Future<void> _handleSticker() async {
    final gif = await GiphyGet.getGif(
      context: context,
      apiKey: 'sniETMI61J0tfBMaFQHAcHURYG1Jn02N',
      lang: GiphyLanguage.vietnamese,
      searchText: "Tìm sticker hoặc GIF",
      modal: true,
    );

    if (gif != null) {
      Provider.of<MessageConversationViewModel>(context, listen: false).sendStickerMessage(
        mediaUrl: gif.images!.original!.url!,
        conversationId: widget.conversationId,
        senderId: widget.currentUserId,
      );
    }
  }

  // Xử lý gửi file
  void _handleFileUpload() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'docx', 'xlsx'],
    );

    if (result != null && result.files.isNotEmpty) {
      final files = result.paths.map((path) => File(path!)).toList();
      final mediaUrls = await FileUploadService().uploadFiles(files);

      final isImage = mediaUrls.every((url) => url.endsWith('.jpg') || url.endsWith('.png'));

      Provider.of<MessageConversationViewModel>(context, listen: false).sendFileMessage(
        mediaUrls: mediaUrls,
        conversationId: widget.conversationId,
        senderId: widget.currentUserId,
        isImage: isImage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: SafeArea(
        child: Row(
          children: [
            // Gửi sticker/GIF
            IconButton(
              icon: const Icon(Icons.emoji_emotions_outlined),
              onPressed: _handleSticker,
            ),
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: _handleFileUpload,
            ),

            IconButton(icon: const Icon(Icons.mic, color: Colors.deepPurple), onPressed: () {}),

            // Ô nhập tin nhắn
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Nhập tin nhắn...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            // Nút gửi tin nhắn
            IconButton(
              icon: const Icon(Icons.send, color: Colors.deepPurple),
              onPressed: _handleSend,
            ),
          ],
        ),
      ),
    );
  }
}
