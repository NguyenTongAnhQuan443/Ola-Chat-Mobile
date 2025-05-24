import 'package:flutter/material.dart';
import 'package:olachat_mobile/models/notification_model.dart';
import 'package:olachat_mobile/services/notification_service.dart';
import 'package:olachat_mobile/services/token_service.dart';
import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';

class NotificationViewModel extends ChangeNotifier {
  List<NotificationModel> topNotifications = [];
  List<NotificationModel> allNotifications = [];
  int currentPage = 0;
  bool hasMore = true;
  bool isLoadingFullList = false;
  bool isLoadingTop = false;

  List<Map<String, String?>> visibleFriendRequests = [];
  Map<String, String?> friendRequestLoadingMap = {};

  bool isButtonLoading(String userId, String action) =>
      friendRequestLoadingMap[userId] == action;

  void setButtonLoading(String userId, String? action) {
    friendRequestLoadingMap[userId] = action;
    notifyListeners();
  }

  Future<void> fetchTopNotifications() async {
    isLoadingTop = true;
    notifyListeners();

    try {
      final result = await NotificationService.fetchNotifications(
        page: 0,
        size: 3,
      );
      topNotifications = result;
    } catch (e) {
      debugPrint("Lỗi fetchTopNotifications: $e");
    } finally {
      isLoadingTop = false;
      notifyListeners();
    }
  }

  Future<void> fetchFriendRequests() async {
    try {
      final token = await TokenService.getAccessToken();
      if (token == null) throw Exception("Token không tồn tại");

      final dio = Dio();
      final response = await dio.get(
        ApiConfig.getReceivedFriendRequests,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data;

      if (response.statusCode == 200 && data['data'] != null) {
        visibleFriendRequests = (data['data'] as List)
            .map<Map<String, String?>>((item) {
              return {
                'requestId': item['requestId'],
                'userId': item['userId'],
                'name': item['displayName'] ?? 'Ẩn danh',
                'avatar': item['avatar'],
              };
            })
            .take(3)
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Lỗi fetchFriendRequests: $e");
    }
  }

  Future<void> initPagination() async {
    currentPage = 0;
    hasMore = true;
    allNotifications.clear();
    await fetchMoreNotifications();
  }

  Future<void> fetchMoreNotifications() async {
    isLoadingFullList = true;
    notifyListeners();

    try {
      final result = await NotificationService.fetchNotifications(
        page: currentPage,
        size: 10,
      );
      allNotifications.addAll(result);
      currentPage++;
      if (result.length < 10) hasMore = false;
    } catch (e) {
      debugPrint("Lỗi fetchMoreNotifications: $e");
    } finally {
      isLoadingFullList = false;
      notifyListeners();
    }
  }
}
