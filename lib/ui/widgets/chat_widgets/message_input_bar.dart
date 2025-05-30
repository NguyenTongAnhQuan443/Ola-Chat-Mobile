import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import '../../../services/file_upload_service.dart';
import '../../../services/voice_recorder_service.dart';
import '../../../utils/app_styles.dart';
import '../../../view_models/message_conversation_view_model.dart';

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
  String? recordingPath;

  // Gửi tin nhắn text
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

  // Gửi sticker hoặc GIF
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

  // Gửi file
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

  // Ghi âm voice
  void _startRecording() async {
    recordingPath = await VoiceRecorderService.startRecording();
  }

  void _stopRecording() async {
    final path = await VoiceRecorderService.stopRecording();
    if (path != null) {
      final file = File(path);

      if (!await file.exists() || await file.length() == 0) {
        print("${AppStyles.failureIcon} Voice file không tồn tại hoặc rỗng");
        return;
      }

      final audioUrl = await FileUploadService().uploadAudioFile(file);
      if (audioUrl != null) {
        Provider.of<MessageConversationViewModel>(context, listen: false).sendAudioMessage(
          audioUrl: audioUrl,
          conversationId: widget.conversationId,
          senderId: widget.currentUserId,
        );
      }
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
            IconButton(
              icon: const Icon(Icons.emoji_emotions_outlined),
              onPressed: _handleSticker,
            ),
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: _handleFileUpload,
            ),
            GestureDetector(
              onLongPressStart: (_) => _startRecording(),
              onLongPressEnd: (_) => _stopRecording(),
              child: const Icon(Icons.mic, color: Colors.deepPurple),
            ),
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
