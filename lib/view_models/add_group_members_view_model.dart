import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/config/api_config.dart';
import '../../data/models/friend_model.dart';
import '../../data/services/token_service.dart';

class AddGroupMembersViewModel extends ChangeNotifier {
  List<FriendModel> _friends = [];
  List<String> _selectedUserIds = [];
  bool _isLoading = false;
  bool _isSubmitting = false;

  List<FriendModel> get friends => _friends;
  List<String> get selectedUserIds => _selectedUserIds;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;

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
      final token = await TokenService.getAccessToken();
      final response = await http.get(Uri.parse(ApiConfig.getMyFriends), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> data = json['data'];
        _friends = data.map((e) => FriendModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("❌ fetchFriends error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addMembersToGroup(String groupId) async {
    if (_selectedUserIds.isEmpty) return false;

    _isSubmitting = true;
    notifyListeners();

    try {
      final token = await TokenService.getAccessToken();
      final body = jsonEncode({"userIds": _selectedUserIds});
      final res = await http.post(
        Uri.parse(ApiConfig.addMembersToGroup(groupId)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      _isSubmitting = false;
      notifyListeners();
      return res.statusCode == 200;
    } catch (e) {
      print("❌ addMembersToGroup error: $e");
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }
}
