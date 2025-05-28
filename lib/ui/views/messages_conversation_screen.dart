import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:olachat_mobile/config/agora_config.dart';
import 'package:olachat_mobile/ui/views/video_player_screen.dart';
import 'package:provider/provider.dart';
import '../../models/enum/message_type.dart';
import '../../models/message_model.dart';
import '../../services/socket_service.dart';
import '../../services/token_service.dart';
import '../../view_models/message_conversation_view_model.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:file_picker/file_picker.dart';

import 'call_video_screen.dart';
import 'group_management_screen.dart';

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
  List<PlatformFile> _selectedFiles = [];

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

      final vm =
          Provider.of<MessageConversationViewModel>(context, listen: false);
      await vm.init(widget.conversationId);

      _jumpToBottom();
    });
  }

  // Send MEDIA
  Future<void> _pickMediaFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'mp4', 'mov', 'webm'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles = result.files;
      });
    }
  }

  // Send Message
  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      Provider.of<MessageConversationViewModel>(context, listen: false)
          .sendTextMessage(widget.conversationId, content);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  // Send Sticker
  void _sendSticker(String url) {
    Provider.of<MessageConversationViewModel>(context, listen: false)
        .sendSticker(widget.conversationId, url);
  }

  // Cuộn
  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  // Cuộn
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

  // Open Grid Sticker
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
        print('Không tìm thấy URL cho sticker.');
      }
    }
  }

  // Widget
  Widget _buildMessageContent(MessageModel msg) {
    void _showImagePreview(String imageUrl) {
      final screenSize = MediaQuery.of(context).size;
      final dialogWidth = screenSize.width * 0.8;
      final dialogHeight = screenSize.height * 0.8;

      showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (_) => Stack(
          children: [
            // Nền blur
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),

            // Center để giữ khung dialog
            Center(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: dialogWidth,
                    height: dialogHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.transparent,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: InteractiveViewer(
                      maxScale: 4.0,
                      child: Center(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Nút X
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (msg.type == MessageType.STICKER) {
      final stickerUrl =
          msg.mediaUrls?.isNotEmpty == true ? msg.mediaUrls![0] : "";
      if (stickerUrl.isEmpty) return const SizedBox();
      return GestureDetector(
        onTap: () => _showImagePreview(stickerUrl),
        child: Image.network(
          stickerUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 48),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              Future.microtask(() => _scrollToBottom());
              return child;
            }
            return const SizedBox(
              width: 100,
              height: 100,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          },
        ),
      );
    }

    if (msg.type == MessageType.MEDIA) {
      final urls = msg.mediaUrls ?? [];
      if (urls.isEmpty) return const SizedBox();
      return Wrap(
        spacing: 6,
        runSpacing: 6,
        children: urls.map<Widget>((url) {
          final isVideo = url.endsWith('.mp4') || url.endsWith('.mov');
          return isVideo
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          backgroundColor: Colors.black,
                          body: Stack(
                            children: [
                              Center(
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: VideoPlayerScreen(videoUrl: url),
                                ),
                              ),
                              Positioned(
                                top: 32,
                                right: 16,
                                child: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.play_circle_fill,
                        size: 40, color: Colors.white),
                  ),
                )
              : GestureDetector(
                  onTap: () => _showImagePreview(url),
                  child: Image.network(
                    url,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        Future.microtask(() => _scrollToBottom());
                        return child;
                      }
                      return const SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    },
                  ),
                );
        }).toList(),
      );
    }

    // Trường hợp text
    return Text(msg.content, style: const TextStyle(fontSize: 15));
  }

  Widget _buildSentMessage(MessageModel msg, String time) {
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
                // if (type == MessageType.STICKER.name)
                //   _buildMessageContent(message, type)
                // else
                //   Container(
                //     padding: const EdgeInsets.all(12),
                //     decoration: BoxDecoration(
                //       color: const Color(0xFFE5DEFF),
                //       borderRadius: const BorderRadius.only(
                //         topLeft: Radius.circular(16),
                //         topRight: Radius.circular(16),
                //         bottomLeft: Radius.circular(16),
                //       ),
                //     ),
                //     child: _buildMessageContent(message, type),
                //   ),
                // const SizedBox(height: 4),
                // Text(time,
                //     style: const TextStyle(color: Colors.grey, fontSize: 11)),
                _buildMessageContent(msg),
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

  Widget _buildReceivedMessage(
      {required MessageModel msg, required String time}) {
    final vm =
        Provider.of<MessageConversationViewModel>(context, listen: false);
    final isGroupChat = vm.userMap.length > 1;
    final avatarUrl = isGroupChat
        ? (vm.userMap[msg.senderId]?.avatar ?? "")
        : widget.avatarUrl;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundImage: avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : const AssetImage('assets/images/default_avatar.png')
                    as ImageProvider,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // isMediaOrSticker
                //     ? _buildMessageContent(message, type)
                //     : Container(
                //         padding: const EdgeInsets.all(12),
                //         decoration: const BoxDecoration(
                //           color: Color(0xFFF1F4F9),
                //           borderRadius: BorderRadius.only(
                //             topLeft: Radius.circular(16),
                //             topRight: Radius.circular(16),
                //             bottomRight: Radius.circular(16),
                //           ),
                //         ),
                //         child: _buildMessageContent(message, type),
                //       ),
                // const SizedBox(height: 4),
                // Text(
                //   time,
                //   style: const TextStyle(color: Colors.grey, fontSize: 11),
                // ),
                _buildMessageContent(msg),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
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
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: () {
              _openGiphyStickerPicker();
            },
          ),
          IconButton(
            icon: const Icon(Icons.image_outlined),
            onPressed: () async {
              await _pickMediaFiles();

              if (_selectedFiles.isEmpty) {
                print('[DEBUG] Không có file nào được chọn.');
                return;
              }
              try {
                final vm = Provider.of<MessageConversationViewModel>(context,
                    listen: false);
                await vm.sendMediaMessage(
                    widget.conversationId, _selectedFiles);

                setState(() {
                  _selectedFiles.clear(); // reset sau khi gửi
                });
                _scrollToBottom();
              } catch (e) {
                print('[DEBUG] Lỗi khi gửi media: $e');
              }
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
          actions: [
            IconButton(
              icon: const Icon(Icons.call, color: Color(0xFF4C68D5)), // Voice call
              tooltip: 'Gọi thoại',
              onPressed: () {
                // TODO: Thực hiện gọi thoại
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tính năng gọi thoại chưa khả dụng')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.videocam, color: Color(0xFF4C68D5)), // Video call
              tooltip: 'Gọi video',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CallVideoScreen(
                      channelName: widget.conversationId,
                      avatarUrl: "http://res.cloudinary.com/dm5ulzy7n/image/upload/v1748106975/travel/bbyvzr6s3p4yfa1fqrzm.jpg",
                      // token: ...
                    ),
                  ),
                );

              },
            ),
            // PopupMenuButton<String>(
            //   onSelected: (value) {
            //     if (value == 'manage') {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (_) => GroupManagementScreen(
            //             conversationId: widget.conversationId,
            //             groupName: widget.conversationName,
            //             groupAvatar: widget.avatarUrl,
            //           ),
            //         ),
            //       );
            //     }
            //   },
            //   itemBuilder: (context) => [
            //     const PopupMenuItem<String>(
            //       value: 'manage',
            //       child: Text('Thông tin nhóm'),
            //     ),
            //   ],
            // ),
          ],
        ),
        body: Column(
          children: [
            // Theo dõi số lượng tin nhắn để focus tin nhắn mới nhất
            Selector<MessageConversationViewModel, int>(
              selector: (_, vm) => vm.messages.length,
              builder: (context, messageCount, child) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _autoScrollIfNeeded());
                return const SizedBox.shrink();
              },
            ),

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
                        final content = msg.type == MessageType.MEDIA
                            ? jsonEncode(msg.mediaUrls ?? [])
                            : msg.content;

                        return isMe
                            ? _buildSentMessage(msg, _formatTime(msg.createdAt))
                            : _buildReceivedMessage(
                                msg: msg,
                                time: _formatTime(msg.createdAt),
                              );
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

  void _autoScrollIfNeeded() {
    if (!_scrollController.hasClients) return;

    final current = _scrollController.position.pixels;
    final max = _scrollController.position.maxScrollExtent;
    final distance = (max - current).abs();

    if (distance < 300) {
      _scrollController.animateTo(
        max,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
