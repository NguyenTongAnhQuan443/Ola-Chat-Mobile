import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.emoji_emotions_outlined), onPressed: () {}),
            IconButton(icon: const Icon(Icons.image_outlined), onPressed: () {}),
            IconButton(icon: const Icon(Icons.mic, color: Colors.deepPurple), onPressed: () {}),
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
