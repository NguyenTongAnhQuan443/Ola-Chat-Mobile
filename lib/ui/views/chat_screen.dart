import 'package:flutter/material.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import '../../models/message_model.dart';
import '../../services/message_service.dart';
import '../../services/token_service.dart';
import '../widgets/chat_widgets/chat_app_bar.dart';
import '../widgets/chat_widgets/message_bubble.dart';
import '../widgets/chat_widgets/message_input_bar.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final String userId;
  final String conversationId;

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
  String? currentUserName;

  @override
  void initState() {
    super.initState();
    debugPrint("[ChatScreen] mở với conversationId: ${widget.conversationId}");
    _loadMessages();
    _loadUserName();
  }

  // Hàm bất đồng bộ để lấy tên người dùng từ local (token)
  Future<void> _loadUserName() async {
    final name = await TokenService.getCurrentUserName();
    setState(() {
      currentUserName = name ?? "Bạn";
    });
  }

  // Hàm bất đồng bộ để lấy tin nhắn từ API với phân trang
  Future<void> _loadMessages() async {
    try {
      final fetched = await _messageService.fetchMessages(
        conversationId: widget.conversationId,
        page: 0,
        size: 20,
      );

      setState(() {
        messages = fetched; // Cập nhật danh sách tin nhắn
      });
    } catch (e) {
      debugPrint("${AppStyles.redPointIcon}Error loading messages: $e");
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
          currentUserName: currentUserName ?? 'Bạn',
        ),

        // Giao diện chính: danh sách tin nhắn + input bar
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: false, // Tin nhắn mới nằm dưới cùng
                padding: const EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  // Đảo ngược danh sách để hiển thị tin nhắn theo thứ tự cũ -> mới
                  final msg = messages[messages.length - 1 - index];

                  // Xác định xem tin nhắn có phải của người dùng hiện tại không
                  final isMe = msg.senderId == widget.userId;

                  // Hiển thị bong bóng tin nhắn
                  return MessageBubble(message: msg, isMe: isMe);
                },
              ),
            ),

            const Divider(height: 1),
            const MessageInputBar(), // Thanh nhập tin nhắn
          ],
        ),
      ),
    );
  }
}
