import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/friend_request_dto.dart';
import '../data/services/friend_request_service.dart';

class FriendRequestViewModel extends ChangeNotifier {
  final FriendRequestService _service = FriendRequestService();
  bool isLoading = false;

  Future<void> sendRequest({
    required String senderId,
    required String receiverId,
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();

    final request = FriendRequestDTO(senderId: senderId, receiverId: receiverId);
    final success = await _service.sendFriendRequest(request);

    isLoading = false;
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "✅ Đã gửi lời mời kết bạn!" : "❌ Gửi lời mời thất bại!"),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_info');
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      return userMap['userId'];
    }
    return null;
  }
}
