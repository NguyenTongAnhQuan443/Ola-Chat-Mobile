import 'package:flutter/material.dart';
import 'package:olachat_mobile/models/friend_request_model.dart';
import 'package:olachat_mobile/services/friend_request_service.dart';
import '../ui/widgets/show_snack_bar.dart';

class FriendRequestViewModel extends ChangeNotifier {
  final FriendRequestService _service = FriendRequestService();
  bool isLoading = false;

  Set<String> sentRequestIds = {};
  Set<String> receivedRequestIds = {};
  Map<String, Map<String, String>> receivedRequestMap = {};
  Map<String, String?> friendRequestLoadingMap = {};

  Future<void> sendRequest({
    required String senderId,
    required String receiverId,
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();

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

    notifyListeners();
  }

  Future<void> cancelRequest({
    required String receiverId,
    required BuildContext context,
  }) async {
    if (!sentRequestIds.contains(receiverId)) {
      showErrorSnackBar(context, "Không tìm thấy lời mời đã gửi tới người này!, ${receiverId}");
      return;
    }

    isLoading = true;
    notifyListeners();

    final success = await _service.cancelFriendRequest(receiverId);

    isLoading = false;

    if (success) {
      showSuccessSnackBar(context, "Đã hủy lời mời kết bạn");
      await fetchSentRequests();
    } else {
      showErrorSnackBar(context, "Hủy lời mời thất bại");
    }

    notifyListeners();
  }


  Future<void> fetchSentRequests() async {
    try {
      sentRequestIds = await _service.fetchSentRequests();
      notifyListeners();
    } catch (e) {
      debugPrint("fetchSentRequests error: $e");
    }
  }

  Future<void> fetchReceivedRequests() async {
    try {
      receivedRequestIds.clear();
      receivedRequestMap.clear();
      final receivedList = await _service.fetchReceivedRequests();
      for (var item in receivedList) {
        final userId = item['userId'];
        final requestId = item['requestId'];
        final displayName = item['displayName'];
        if (userId != null && requestId != null) {
          receivedRequestIds.add(userId);
          receivedRequestMap[userId] = {
            'requestId': requestId,
            'displayName': displayName ?? 'Ẩn danh',
          };
        }
      }
      notifyListeners();
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
      final requestId = await findRequestIdFrom(senderId);
      final success = await _service.acceptRequest(requestId);
      if (success) {
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
      final requestId = await findRequestIdFrom(senderId);
      final success = await _service.rejectRequest(requestId);
      if (success) {
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
}
