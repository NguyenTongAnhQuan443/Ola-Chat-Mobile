import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/models/friend_model.dart';
import 'package:olachat_mobile/services/dio_client.dart';

class CreateGroupViewModel extends ChangeNotifier {
  List<FriendModel> _friends = [];
  List<String> _selectedUserIds = [];
  bool _isLoading = false;

  List<FriendModel> get friends => _friends;
  List<String> get selectedUserIds => _selectedUserIds;
  bool get isLoading => _isLoading;

  void toggleUserSelection(String userId) {
    if (_selectedUserIds.contains(userId)) {
      _selectedUserIds.remove(userId);
    } else {
      _selectedUserIds.add(userId);
    }
    notifyListeners();
  }

  Future<void> fetchFriends() async {
    _isLoading = true;
    notifyListeners();

    try {
      final dio = DioClient().dio;
      final response = await dio.get(ApiConfig.getMyFriends);

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        _friends = data.map((e) => FriendModel.fromJson(e)).toList();
      } else {
        print("[FRIENDS] Lỗi khi fetch: ${response.statusCode}");
      }
    } catch (e) {
      print("[FRIENDS] Lỗi kết nối: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createGroup({
    required String name,
    String avatarUrl = '',
  }) async {
    try {
      final dio = DioClient().dio;

      final Map<String, dynamic> body = {
        'name': name,
        'userIds': _selectedUserIds,
      };

      if (avatarUrl.isNotEmpty) {
        body['avatar'] = avatarUrl;
      }

      final response = await dio.post(
        ApiConfig.createGroup,
        data: body,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("[GROUP] Lỗi tạo nhóm: $e");
      return false;
    }
  }
}
