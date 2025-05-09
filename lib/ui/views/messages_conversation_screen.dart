import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:olachat_mobile/core/utils/config/api_config.dart';
import 'package:olachat_mobile/data/services/token_service.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../../data/enum/message_type.dart';
import '../../data/models/message_model.dart';
import '../../data/services/socket_service.dart';
import '../../view_models/message_conversation_view_model.dart';
import 'package:giphy_get/giphy_get.dart';

class MessagesConversationScreen extends StatefulWidget {
  final String conversationId;
  final String conversationName;
  final String avatarUrl;

  const MessagesConversationScreen({
    super.key,
    required this.conversationId,
    required this.conversationName,
    required this.avatarUrl,
  });

  @override
  State<MessagesConversationScreen> createState() =>
      _MessagesConversationScreenState();
}

class _MessagesConversationScreenState
    extends State<MessagesConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _accessToken;
  String? _userId;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final token = await TokenService.getAccessToken();
      final userInfo = await TokenService.getUserInfo();

      if (userInfo != null) {
        final userMap = jsonDecode(userInfo);
        setState(() {
          _userId = userMap['userId'];
        });
      }

      SocketService().init(token!);

      final vm = Provider.of<MessageConversationViewModel>(context, listen: false);
      await vm.init(widget.conversationId);

      _jumpToBottom();
    });
  }


  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      Provider.of<MessageConversationViewModel>(context, listen: false)
          .sendTextMessage(widget.conversationId, content);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _sendSticker(String url) {
    Provider.of<MessageConversationViewModel>(context, listen: false)
        .sendSticker(widget.conversationId, url);
  }

  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  Future<void> _openGiphyStickerPicker() async {
    GiphyGif? gif = await GiphyGet.getGif(
      context: context,
      apiKey: 'sniETMI61J0tfBMaFQHAcHURYG1Jn02N',
      tabColor: Colors.blue,
      showStickers: true,
      searchText: 'Tìm sticker...',
      modal: true,
    );

    if (gif != null) {
      final stickerUrl = gif.images?.original?.url;
      if (stickerUrl != null) {
        _sendSticker(stickerUrl);
      } else {
        print('⚠️ Không tìm thấy URL cho sticker.');
      }
    }
  }

  Widget _buildMessageContent(String content, String type) {
    if (type == MessageType.STICKER.name) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          content,
          width: 160,
          height: 160,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 48),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              // Ảnh đã load xong
              Future.microtask(() => _scrollToBottom());
              return child;
            }
            return const SizedBox(
                width: 140,
                height: 140,
                child:
                    Center(child: CircularProgressIndicator(strokeWidth: 2)));
          },
        ),
      );
    }

    return Text(content, style: const TextStyle(fontSize: 15));
  }

  // Widget _buildSentMessage(String message, String type, String time) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: [
  //         Flexible(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: [
  //               if (type == MessageType.STICKER.name)
  //                 _buildMessageContent(message, type)
  //               else
  //                 Container(
  //                   padding: const EdgeInsets.all(12),
  //                   decoration: const BoxDecoration(
  //                     color: Color(0xFF4C68D5),
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(16),
  //                       topRight: Radius.circular(16),
  //                       bottomLeft: Radius.circular(16),
  //                     ),
  //                   ),
  //                   child: _buildMessageContent(message, type),
  //                 ),
  //               const SizedBox(height: 4),
  //               Text(time,
  //                   style: const TextStyle(color: Colors.grey, fontSize: 11)),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildSentMessage(String message, String type, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (type == MessageType.STICKER.name)
                  _buildMessageContent(message, type)
                else
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5DEFF), // 💜 tím nhạt
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: _buildMessageContent(message, type),
                  ),
                const SizedBox(height: 4),
                Text(time,
                    style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildReceivedMessage(String message, String type, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundImage: widget.avatarUrl.isNotEmpty
                ? NetworkImage(widget.avatarUrl)
                : const AssetImage('assets/images/default_avatar.png')
                    as ImageProvider,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (type == MessageType.STICKER.name)
                  _buildMessageContent(message, type)
                else
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F4F9),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: _buildMessageContent(message, type),
                  ),
                const SizedBox(height: 4),
                Text(time,
                    style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // Gỡ bỏ icon file và gif
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: () {
              _openGiphyStickerPicker();
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: "Nhập tin nhắn...",
                  border: InputBorder.none,
                ),
                minLines: 1,
                maxLines: 5,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF4C68D5),
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final local = time.toLocal();
    return "${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MessageConversationViewModel>(context);
    final messages = vm.messages;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: widget.avatarUrl.isNotEmpty
                    ? NetworkImage(widget.avatarUrl)
                    : const AssetImage('assets/images/default_avatar.png')
                        as ImageProvider,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.conversationName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text("Online",
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMe = msg.senderId == _userId;
                        return isMe
                            ? _buildSentMessage(msg.content, msg.type.name,
                                _formatTime(msg.createdAt))
                            : _buildReceivedMessage(msg.content, msg.type.name,
                                _formatTime(msg.createdAt));
                      },
                    ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
