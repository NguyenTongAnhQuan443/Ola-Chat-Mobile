import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:olachat_mobile/core/utils/config/api_config.dart';
import 'package:olachat_mobile/data/services/token_service.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../data/enum/message_type.dart';
import '../../data/models/message_model.dart';
import '../../view_models/message_view_model.dart';

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
  StompClient? _stompClient;
  String? _accessToken;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initSocket();
    Future.microtask(() async {
      final vm = Provider.of<MessageViewModel>(context, listen: false);
      await vm.loadMessages(widget.conversationId);
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _initSocket() async {
    _accessToken = await TokenService.getAccessToken();

    final userInfoJson = await TokenService.getUserInfo();
    if (userInfoJson != null) {
      try {
        final userMap = jsonDecode(userInfoJson);
        _userId = userMap['userId'];
      } catch (e) {
        print('❌ Lỗi khi parse user info: $e');
      }
    }

    _stompClient = StompClient(
      config: StompConfig(
        url: ApiConfig.socketUrl,
        onConnect: _onConnect,
        beforeConnect: () async {
          print('📡 Connecting to socket...');
          await Future.delayed(const Duration(milliseconds: 200));
        },
        onWebSocketError: (error) => print('❌ Socket Error: $error'),
        stompConnectHeaders: {'Authorization': 'Bearer $_accessToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $_accessToken'},
        heartbeatOutgoing: const Duration(seconds: 10),
        heartbeatIncoming: const Duration(seconds: 10),
        reconnectDelay: const Duration(seconds: 5),
      ),
    );

    _stompClient!.activate();
  }

  void _onConnect(StompFrame frame) {
    print('✅ Socket connected');
    _stompClient!.subscribe(
      destination: '/user/${widget.conversationId}/private',
      callback: _onMessageReceived,
    );
  }

  void _onMessageReceived(StompFrame frame) {
    final json = jsonDecode(frame.body!);
    final msg = MessageModel.fromJson(json);
    Provider.of<MessageViewModel>(context, listen: false).addMessage(msg);
    _scrollToBottom();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _stompClient?.deactivate();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildReceivedMessage(String message, String time) {
    return Padding(
      padding: const EdgeInsets.only(right: 50, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(message, style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSentMessage(String message, String time) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4C68D5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: widget.avatarUrl.isNotEmpty
                ? NetworkImage(widget.avatarUrl)
                : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "Message ...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF6174D9)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      final content = _messageController.text.trim();
                      if (content.isNotEmpty && _stompClient?.connected == true && _userId != null) {
                        final msg = {
                          'senderId': _userId,
                          'conversationId': widget.conversationId,
                          'content': content,
                          'type': MessageType.TEXT.name,
                        };
                        try {
                          _stompClient!.send(
                            destination: '/app/private-message',
                            body: jsonEncode(msg),
                            headers: {'Authorization': 'Bearer $_accessToken'},
                          );

                          final model = MessageModel(
                            id: '',
                            senderId: _userId!,
                            conversationId: widget.conversationId,
                            content: content,
                            type: MessageType.TEXT,
                            createdAt: DateTime.now(),
                            recalled: false,
                          );

                          Provider.of<MessageViewModel>(context, listen: false).addMessage(model);
                          print('📤 Đã gửi (chờ xác nhận): $content');
                          _scrollToBottom();
                        } catch (e) {
                          print('❌ Gửi tin nhắn thất bại: $e');
                        }
                        _messageController.clear();
                      } else {
                        print('⚠️ Không thể gửi: thiếu nội dung hoặc chưa lấy được userId');
                      }
                    },
                  ),
                ],
              ),
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
    final vm = Provider.of<MessageViewModel>(context);
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
                    : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
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
                    const Text("Online", style: TextStyle(color: Colors.grey, fontSize: 12)),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isMe = msg.senderId == _userId;
                  return isMe
                      ? _buildSentMessage(msg.content, _formatTime(msg.createdAt))
                      : _buildReceivedMessage(msg.content, _formatTime(msg.createdAt));
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }
}
