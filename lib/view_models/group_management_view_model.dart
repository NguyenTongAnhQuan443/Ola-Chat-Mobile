import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/utils/config/api_config.dart';
import '../data/services/api_service.dart';
import '../data/services/token_service.dart';

class GroupManagementViewModel extends ChangeNotifier {
  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  Future<bool> updateGroup({
    required String groupId,
    String? name,
    String? avatarUrl,
  }) async {
    if (name == null && avatarUrl == null) return false;

    _isUpdating = true;
    notifyListeners();

    final token = await TokenService.getAccessToken();

    final Map<String, dynamic> body = {};
    if (name != null) body['name'] = name;
    if (avatarUrl != null) body['avatar'] = avatarUrl;

    final response = await http.put(
      Uri.parse(ApiConfig.updateGroup(groupId)),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    _isUpdating = false;
    notifyListeners();

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint("Cập nhật nhóm thất bại: ${response.body}");
      return false;
    }
  }

//
  Future<bool> addMembersToGroup(String groupId, List<String> userIds) async {
    try {
      final response = await ApiService().post(
        ApiConfig.addMembersToGroup(groupId),
        data: {'userIds': userIds},
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Lỗi khi thêm thành viên vào nhóm: $e");
      return false;
    }
  }
}
