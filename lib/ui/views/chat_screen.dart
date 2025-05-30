import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../../models/enum/message_type.dart';
import '../../models/message_model.dart';
import '../../services/message_service.dart';
import '../widgets/chat_widgets/chat_app_bar.dart';
import '../widgets/chat_widgets/message_bubble.dart';
import '../widgets/chat_widgets/message_input_bar.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final String userId;
  final String conversationId; // ✅ Thêm conversationId

  const ChatScreen({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.isOnline,
    required this.userId,
    required this.conversationId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageModel> messages = [];
  final MessageService _messageService = MessageService();

  @override
  void initState() {
    super.initState();
    debugPrint("📩 ChatScreen mở với conversationId: ${widget.conversationId}");
    _loadMessages(); // Gọi API để load tin nhắn khi mở màn hình
  }

  Future<void> _loadMessages() async {
    try {
      final fetched = await _messageService.fetchMessages(
        conversationId: widget.conversationId, // ✅ Dùng conversationId
        page: 0,
        size: 20,
      );

      setState(() {
        messages = fetched;
      });
    } catch (e) {
      debugPrint("❌ Error loading messages: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: ChatAppBar(
          name: widget.name,
          avatarUrl: widget.avatarUrl,
          isOnline: widget.isOnline,
          conversationId: widget.conversationId,
          currentUserId: widget.userId,
          currentUserName:
              'Tên của bạn', // Có thể lấy từ SharedPreferences nếu cần
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: false,
                padding: const EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[messages.length - 1 - index];
                  final isMe = msg.senderId == widget.userId;
                  return MessageBubble(message: msg, isMe: isMe);
                },
              ),
            ),
            const Divider(height: 1),
            const MessageInputBar(),
          ],
        ),
      ),
    );
  }
}
