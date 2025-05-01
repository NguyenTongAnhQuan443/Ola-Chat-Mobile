import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../core/utils/config/api_config.dart';
import '../data/models/friend_request_model.dart';
import '../data/services/friend_request_service.dart';
import '../ui/widgets/show_snack_bar.dart';

class FriendRequestViewModel extends ChangeNotifier {
  final FriendRequestService _service = FriendRequestService();
  bool isLoading = false;

  // Danh sách userId mà mình đã gửi lời mời kết bạn
  Set<String> sentRequestIds = {};

  Future<void> sendRequest({
    required String senderId,
    required String receiverId,
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();

    final request = FriendRequestModel(senderId: senderId, receiverId: receiverId);
    final success = await _service.sendFriendRequest(request);

    isLoading = false;

    if (success) {
      await fetchSentRequests(); // Đồng bộ lại với DB
      showSuccessSnackBar(context, "Đã gửi lời mời kết bạn!");
    } else {
      showErrorSnackBar(context, "Gửi lời mời thất bại!");
    }

    notifyListeners();
  }

  // Gọi API lấy danh sách các userId đã gửi lời mời kết bạn
  Future<void> fetchSentRequests() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiConfig.getSentFriendRequests),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes))['data'];
        sentRequestIds = Set<String>.from(data.map((item) => item['userId']));
        notifyListeners();
      } else {
        debugPrint("⚠️ Lỗi fetchSentRequests: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Exception in fetchSentRequests: $e");
    }
  }

  // Kiểm tra người dùng này đã được gửi lời mời chưa
  bool isRequestSent(String userId) => sentRequestIds.contains(userId);

  // Hủy lời mời kết bạn đã gửi
  Future<void> cancelRequest({
    required String receiverId,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) return;

      final response = await http.delete(
        Uri.parse(ApiConfig.cancelFriendRequest(receiverId)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        showSuccessSnackBar(context, "Đã hủy lời mời kết bạn");
        await fetchSentRequests(); // Đồng bộ lại
      } else {
        showErrorSnackBar(context, "Hủy lời mời thất bại");
      }
    } catch (e) {
      debugPrint("❌ cancelRequest error: $e");
      showErrorSnackBar(context, "Lỗi hệ thống");
    }
  }


  // Lấy userId hiện tại
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
