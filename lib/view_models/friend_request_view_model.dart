import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/models/friend_request_model.dart';
import 'package:olachat_mobile/services/friend_request_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../ui/widgets/show_snack_bar.dart';

class FriendRequestViewModel extends ChangeNotifier {
  final FriendRequestService _service = FriendRequestService();
  bool isLoading = false;

  Set<String> sentRequestIds = {};
  Set<String> receivedRequestIds = {};

  /// Lưu cả requestId và displayName
  Map<String, Map<String, String>> receivedRequestMap = {};

  Map<String, String?> friendRequestLoadingMap = {};

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> sendRequest({
    required String senderId,
    required String receiverId,
    required BuildContext context,
  }) async {
    isLoading = true;
    Future.microtask(() => notifyListeners());

    final request =
        FriendRequestModel(senderId: senderId, receiverId: receiverId);
    final success = await _service.sendFriendRequest(request);

    isLoading = false;

    if (success) {
      await fetchSentRequests();
      showSuccessSnackBar(context, "Đã gửi lời mời kết bạn!");
    } else {
      showErrorSnackBar(context, "Gửi lời mời thất bại!");
    }

    Future.microtask(() => notifyListeners());
  }

  Future<void> cancelRequest({
    required String receiverId,
    required BuildContext context,
  }) async {
    try {
      final token = await getToken();
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
        await fetchSentRequests();
      } else {
        showErrorSnackBar(context, "Hủy lời mời thất bại");
      }
    } catch (e) {
      debugPrint("cancelRequest error: $e");
      showErrorSnackBar(context, "Lỗi hệ thống");
    }
  }

  Future<void> fetchSentRequests() async {
    try {
      final token = await getToken();
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
        Future.microtask(() => notifyListeners());
      }
    } catch (e) {
      debugPrint("fetchSentRequests error: $e");
    }
  }

  Future<void> fetchReceivedRequests() async {
    try {
      final token = await getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiConfig.getReceivedFriendRequests),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final raw = jsonDecode(utf8.decode(response.bodyBytes));
        final data = raw['data'];

        if (data is! List) {
          debugPrint("Data không phải là List!");
          return;
        }

        receivedRequestIds.clear();
        receivedRequestMap.clear();

        for (var item in data) {
          final userId = item['userId']?.toString();
          final requestId = item['requestId']?.toString();
          final displayName = item['displayName']?.toString() ?? "Ẩn danh";

          if (userId != null && requestId != null) {
            receivedRequestIds.add(userId);
            receivedRequestMap[userId] = {
              'requestId': requestId,
              'displayName': displayName,
            };
          }
        }

        Future.microtask(() => notifyListeners());
      } else {
        debugPrint("fetchReceivedRequests lỗi: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("fetchReceivedRequests error: $e");
    }
  }

  bool isRequestSent(String userId) => sentRequestIds.contains(userId);

  bool isReceivedRequestFrom(String userId) =>
      receivedRequestIds.contains(userId);

  String getDisplayName(String userId) {
    return receivedRequestMap[userId]?['displayName'] ?? "Ẩn danh";
  }

  Future<String> findRequestIdFrom(String senderId) async {
    if (!receivedRequestMap.containsKey(senderId)) {
      throw Exception("Không tìm thấy lời mời từ $senderId");
    }
    return receivedRequestMap[senderId]!['requestId']!;
  }

  Future<void> acceptRequest(String senderId, BuildContext context) async {
    try {
      final token = await getToken();
      if (token == null) {
        debugPrint("Token không tồn tại khi xác nhận lời mời từ $senderId");
        showErrorSnackBar(context, "Token không hợp lệ");
        return;
      }

      final requestId = await findRequestIdFrom(senderId);
      final url = ApiConfig.acceptFriendRequest(requestId);

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        showSuccessSnackBar(context, "Đã xác nhận kết bạn!");
        await fetchReceivedRequests();
      } else {
        showErrorSnackBar(context, "Xác nhận thất bại");
      }
    } catch (e) {
      debugPrint("acceptRequest error: $e");
      showErrorSnackBar(context, "Lỗi hệ thống");
    }
  }

  Future<void> rejectRequest(String senderId, BuildContext context) async {
    try {
      final token = await getToken();
      if (token == null) return;

      final requestId = await findRequestIdFrom(senderId);
      final url = ApiConfig.rejectFriendRequest(requestId);

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        showSuccessSnackBar(context, "Đã từ chối lời mời kết bạn!");
        await fetchReceivedRequests();
      } else {
        showErrorSnackBar(context, "Từ chối lời mời thất bại!");
      }
    } catch (e) {
      debugPrint("rejectRequest error: $e");
    }
  }

  bool isButtonLoading(String userId, String action) =>
      friendRequestLoadingMap[userId] == action;

  void setButtonLoading(String userId, String? action) {
    friendRequestLoadingMap[userId] = action;
    notifyListeners();
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
