import 'package:flutter/material.dart';
import 'package:olachat_mobile/models/conversation_model.dart';
import 'package:olachat_mobile/models/last_message_model.dart';
import 'package:olachat_mobile/services/list_conversation_service.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

class ListConversationViewModel extends ChangeNotifier {
  final ListConversationService _service = ListConversationService();
  List<ConversationModel> _conversations = [];
  bool _isLoading = true;

  List<ConversationModel> get conversations => _conversations;
  bool get isLoading => _isLoading;

  // Gọi API để lấy danh sách tất cả các hội thoại
  Future<void> fetchConversations() async {
    _isLoading = true;
    notifyListeners(); // Cập nhật UI ngay khi bắt đầu tải
    print("${AppStyles.successIcon}[ListConversationVM] Bắt đầu fetch conversations");

    try {
      _conversations = await _service.fetchConversations();
    } catch (e) {
      debugPrint("${AppStyles.failureIcon} [ListConversationVM] Error loading conversations: $e");
      _conversations = [];
    } finally {
      _isLoading = false;
      notifyListeners(); // Cập nhật UI sau khi tải xong
    }
  }

  // Hàm gọi khi có tin nhắn mới qua socket hoặc sự kiện realtime
  // Mục tiêu: cập nhật `lastMessage` và đưa hội thoại lên đầu
  Future<void> updateConversationFromMessage(Map<String, dynamic> messageData) async {
    try {
      final String conversationId = messageData['conversationId']; // ID hội thoại
      final String content = messageData['content']; // Nội dung tin nhắn
      final String messageType = messageData['type']; // TEXT / MEDIA
      final DateTime now = DateTime.now(); // Thời gian hiện tại

      // Tìm vị trí hội thoại trong danh sách
      final index = _conversations.indexWhere((c) => c.id == conversationId);

      if (index != -1) {
        // Nếu hội thoại đã tồn tại → cập nhật nội dung tin nhắn cuối
        final updated = _conversations[index];
        updated.lastMessage = LastMessageModel(
          content: messageType == 'TEXT'
              ? content
              : '[Media]', // Nếu không phải TEXT thì hiển thị là [Media]
          createdAt: DateTime.now(),
          senderId: messageData['senderId'],
        );

        updated.updatedAt = now; // Cập nhật thời gian chỉnh sửa
        _conversations.removeAt(index); // Xoá khỏi vị trí cũ
        _conversations.insert(0, updated); // Đưa lên đầu danh sách
      } else {
        // Nếu hội thoại chưa tồn tại → gọi API để fetch hội thoại đó
        final newConversation = await _service.fetchConversationById(conversationId);
        _conversations.insert(0, newConversation); // Thêm vào đầu danh sách
      }

      notifyListeners(); // Cập nhật UI
    } catch (e) {
      debugPrint(
        "${AppStyles.failureIcon} [ListConversationVM] Update Conversation From Message Error: $e",
      );
    }
  }
}
