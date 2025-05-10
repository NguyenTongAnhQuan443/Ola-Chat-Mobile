import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/utils/config/api_config.dart';
import '../data/models/group_member_model.dart';
import '../data/services/token_service.dart';

class GroupMembersRoleViewModel extends ChangeNotifier {
  List<GroupMemberModel> _members = [];
  bool _isLoading = false;

  List<GroupMemberModel> get members => _members;
  bool get isLoading => _isLoading;

  Future<void> fetchGroupMembers(String conversationId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await TokenService.getAccessToken();
      final response = await http.get(
        Uri.parse(ApiConfig.getUsersInConversation(conversationId)),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        _members = data.map((e) => GroupMemberModel.fromJson(e)).toList();
      } else {
        print('❌ Lỗi lấy danh sách thành viên: ${response.body}');
      }
    } catch (e) {
      print('❌ Lỗi khi fetch thành viên: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

//
  Future<bool> removeMember(String groupId, String userId) async {
    try {
      final token = await TokenService.getAccessToken();
      final response = await Dio().delete(
        ApiConfig.removeMemberFromGroup(groupId, userId),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        members.removeWhere((e) => e.userId == userId);
        notifyListeners();
        return true;
      } else {
        print("❌ Xoá thành viên thất bại: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ Lỗi khi xoá thành viên: $e");
      return false;
    }
  }

}
