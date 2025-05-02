import 'package:flutter/material.dart';
import 'package:olachat_mobile/data/services/token_service.dart';
import 'package:olachat_mobile/data/services/notification_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:olachat_mobile/core/utils/config/api_config.dart';

import '../data/models/notification_model.dart';

class NotificationViewModel extends ChangeNotifier {
  // Top 3 notifications for home screen
  List<NotificationModel> topNotifications = [];

  // Full list for AllNotificationsScreen
  List<NotificationModel> allNotifications = [];
  int currentPage = 0;
  bool hasMore = true;
  bool isLoadingFullList = false;

  // Shared loading state
  bool isLoadingTop = false;

  List<Map<String, String>> visibleFriendRequests = [];

  Future<void> fetchTopNotifications() async {
    try {
      isLoadingTop = true;
      notifyListeners();

      final token = await TokenService.getAccessToken();
      if (token == null) throw Exception("Token không tồn tại");

      final result = await NotificationService.fetchNotifications(
        token: token,
        page: 0,
        size: 3,
      );

      topNotifications = result;
      await fetchFriendRequests(token);
    } catch (e) {
      debugPrint("❌ Lỗi fetchTopNotifications: $e");
    } finally {
      isLoadingTop = false;
      notifyListeners();
    }
  }

  Future<void> initPagination() async {
    currentPage = 0;
    hasMore = true;
    allNotifications.clear();
    await fetchMoreNotifications();
  }

  Future<void> fetchMoreNotifications() async {
    try {
      isLoadingFullList = true;
      notifyListeners();

      final token = await TokenService.getAccessToken();
      if (token == null) throw Exception("Token không tồn tại");

      final result = await NotificationService.fetchNotifications(
        token: token,
        page: currentPage,
        size: 10,
      );

      allNotifications.addAll(result);
      currentPage++;
      if (result.length < 10) hasMore = false;
    } catch (e) {
      debugPrint("❌ Lỗi fetchMoreNotifications: $e");
    } finally {
      isLoadingFullList = false;
      notifyListeners();
    }
  }

  Future<void> fetchFriendRequests(String token) async {
    try {
      final url = Uri.parse(ApiConfig.getReceivedFriendRequests);
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && data['data'] != null) {
        visibleFriendRequests = (data['data'] as List).map<Map<String, String>>((item) {
          return {
            'name': item['sender']['fullName'] ?? 'Ẩn danh',
            'mutual': '${item['mutualFriendsCount']} bạn chung'
          };
        }).toList().take(2).toList();
      }
    } catch (e) {
      debugPrint("❌ Lỗi fetchFriendRequests: $e");
    }
  }
}
