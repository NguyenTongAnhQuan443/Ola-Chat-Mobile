import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/utils/config/api_config.dart';
import '../data/models/friend_model.dart';
import '../data/services/token_service.dart';

class GroupMembersViewModel extends ChangeNotifier {
  List<FriendModel> _members = [];
  bool _isLoading = false;

  List<FriendModel> get members => _members;
  bool get isLoading => _isLoading;

  Future<void> fetchGroupMembers(String conversationId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await TokenService.getAccessToken();
      final response = await http.get(
        Uri.parse(ApiConfig.getUsersInConversation(conversationId)),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        _members = data.map((e) => FriendModel.fromJson(e)).toList();
      } else {
        print("⚠️ Lỗi lấy thành viên nhóm: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    }

    _isLoading = false;
    notifyListeners();
  }


}
