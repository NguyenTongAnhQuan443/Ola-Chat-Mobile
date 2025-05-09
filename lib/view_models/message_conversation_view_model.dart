import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../data/enum/message_type.dart';
import '../data/models/message_model.dart';
import '../data/services/file_upload_service.dart';
import '../data/services/message_service.dart';
import '../data/services/socket_service.dart';
import '../data/services/token_service.dart';

class MessageConversationViewModel extends ChangeNotifier {
  final MessageService _messageService = MessageService();
  final SocketService _socketService = SocketService();

  List<MessageModel> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentUserId;

  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> init(String conversationId) async {
    _isLoading = true;
    notifyListeners();

    final userInfo = await TokenService.getUserInfo();
    if (userInfo != null) {
      _currentUserId = jsonDecode(userInfo)['userId'];
    }

    try {
      _messages =
          await _messageService.fetchMessagesByConversationId(conversationId);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendTextMessage(String conversationId, String content) async {
    if (content.trim().isEmpty || _currentUserId == null) return;

    final now = DateTime.now();

    final tempMessage = MessageModel(
      id: null,
      senderId: _currentUserId!,
      conversationId: conversationId,
      content: content.trim(),
      type: MessageType.TEXT,
      mediaUrls: null,
      status: "SENT",
      deliveryStatus: null,
      readStatus: null,
      createdAt: now,
      recalled: false,
      mentions: null,
    );

    // Hiển thị ngay tin nhắn
    addMessage(tempMessage);

    // Gửi lên socket
    final body = tempMessage.toJson();
    _socketService.sendMessage('/app/private-message', body);
  }


  Future<void> sendSticker(String conversationId, String stickerUrl) async {
    if (_currentUserId == null) return;

    final now = DateTime.now();

    // Gửi socket và render UI ngay
    final tempMessage = MessageModel(
      id: null,
      senderId: _currentUserId!,
      conversationId: conversationId,
      content: stickerUrl,
      type: MessageType.STICKER,
      mediaUrls: null,
      status: "SENT",
      deliveryStatus: null,
      readStatus: null,
      createdAt: now,
      recalled: false,
      mentions: null,
    );

    addMessage(tempMessage); // Hiển thị ngay

    // Gửi socket
    final body = tempMessage.toJson(); // Đã có createdAt

    SocketService().sendMessage('/app/private-message', body);
  }

  void addMessage(MessageModel message) {
    _messages.add(message);
    notifyListeners();
  }

  // Send media
  Future<void> sendMediaMessage(String conversationId, List<PlatformFile> files) async {
    if (_currentUserId == null || files.isEmpty) return;

    try {
      final accessToken = await TokenService.getAccessToken();
      final mediaUrls = await FileUploadService.uploadFilesIndividually(
          files, accessToken!);
      print('📤 [DEBUG] mediaUrls gửi đi: ${mediaUrls}');


      final now = DateTime.now();

      final tempMessage = MessageModel(
        id: null,
        senderId: _currentUserId!,
        conversationId: conversationId,
        content: "",
        type: MessageType.MEDIA,
        mediaUrls: mediaUrls,
        status: "SENT",
        deliveryStatus: null,
        readStatus: null,
        createdAt: now,
        recalled: false,
        mentions: null,
      );

      addMessage(tempMessage); // render ngay

      _socketService.sendMessage('/app/private-message', tempMessage.toJson());
    } catch (e) {
      print("❌ Gửi media thất bại: $e");
    }
  }


  void disposeSocket() {
    _socketService.disconnect();
  }
}
