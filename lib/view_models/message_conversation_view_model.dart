import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/enum/message_type.dart';
import '../models/message_model.dart';
import '../models/user_in_conversation_model.dart';
import '../services/conversation_service.dart';
import '../services/file_upload_service.dart';
import '../services/message_service.dart';
import '../services/socket_service.dart';
import '../services/token_service.dart';

class MessageConversationViewModel extends ChangeNotifier {
  final MessageService _messageService = MessageService();
  final SocketService _socketService = SocketService();
  final ConversationService _conversationService = ConversationService();

  Map<String, UserInConversation> _userMap = {};

  Map<String, UserInConversation> get userMap => _userMap;

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

    // Gọi API lấy danh sách thành viên
    await fetchUsersInConversation(conversationId);

    try {
      _messages =
          await _messageService.fetchMessagesByConversationId(conversationId);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();

    if (!_socketService.isConnected) {
      final accessToken = await TokenService.getAccessToken();
      _socketService.init(accessToken!, onConnectCallback: () {
        _subscribeToConversation(conversationId);
      });
    } else {
      _subscribeToConversation(conversationId);
    }
  }

  void _subscribeToConversation(String conversationId) {
    _socketService.subscribe(
      "/user/$conversationId/private",
      (data) {
        try {
          final message = MessageModel.fromJson(data);

          final isDuplicate = _messages.any((m) =>
              (m.id != null && m.id == message.id) ||
              (m.id == null &&
                  m.senderId == message.senderId &&
                  m.content == message.content &&
                  m.createdAt?.millisecondsSinceEpoch ==
                      message.createdAt?.millisecondsSinceEpoch));

          if (!isDuplicate) {
            _messages.add(message);
            notifyListeners();
          }
        } catch (e) {
          print("[SOCKET] Lỗi khi parse message: \$e");
        }
      },
    );
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

    _messages.add(tempMessage);
    notifyListeners();

    final body = tempMessage.toJson();
    _socketService.sendMessage('/app/private-message', body);
  }

  Future<void> sendSticker(String conversationId, String stickerUrl) async {
    if (_currentUserId == null) return;

    final now = DateTime.now();

    final tempMessage = MessageModel(
      id: null,
      senderId: _currentUserId!,
      conversationId: conversationId,
      content: "",
      type: MessageType.STICKER,
      mediaUrls: [stickerUrl],
      status: "SENT",
      deliveryStatus: null,
      readStatus: null,
      createdAt: now,
      recalled: false,
      mentions: null,
    );

    _messages.add(tempMessage);
    notifyListeners();

    _socketService.sendMessage('/app/private-message', tempMessage.toJson());
  }

  Future<void> sendMediaMessage(
      String conversationId, List<PlatformFile> files) async {
    if (_currentUserId == null || files.isEmpty) return;

    try {
      final accessToken = await TokenService.getAccessToken();
      final mediaUrls =
          await FileUploadService.uploadFilesIndividually(files, accessToken!);
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

      _messages.add(tempMessage);
      notifyListeners();

      final json = tempMessage.toJson();

      _socketService.sendMessage('/app/private-message', json);
    } catch (e) {
      print("Gửi media thất bại: $e");
    }
  }

  // Fetch all user in conversation
  Future<void> fetchUsersInConversation(String conversationId) async {
    try {
      _userMap = await _conversationService.getUsersInConversation(conversationId);
      notifyListeners();
    } catch (e) {
      print("Exception khi fetch users in conversation: $e");
    }
  }

  void disposeSocket() {
    _socketService.disconnect();
  }
}
