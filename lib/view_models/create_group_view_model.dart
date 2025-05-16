// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:olachat_mobile/config/api_config.dart';
// import 'package:olachat_mobile/models/friend_model.dart';
// import 'package:olachat_mobile/services/token_service.dart';
//
// class CreateGroupViewModel extends ChangeNotifier {
//   List<FriendModel> _friends = [];
//   List<String> _selectedUserIds = [];
//   bool _isLoading = false;
//
//   List<FriendModel> get friends => _friends;
//   List<String> get selectedUserIds => _selectedUserIds;
//   bool get isLoading => _isLoading;
//
//   void toggleUserSelection(String userId) {
//     if (_selectedUserIds.contains(userId)) {
//       _selectedUserIds.remove(userId);
//     } else {
//       _selectedUserIds.add(userId);
//     }
//     notifyListeners();
//   }
//
//   Future<void> fetchFriends() async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final token = await TokenService.getAccessToken();
//       final res = await http.get(Uri.parse(ApiConfig.getMyFriends), headers: {
//         'Authorization': 'Bearer $token',
//       });
//
//       if (res.statusCode == 200) {
//         final json = jsonDecode(utf8.decode(res.bodyBytes));
//         final List<dynamic> data = json['data'];
//
//         _friends = data.map((e) => FriendModel.fromJson(e)).toList();
//       } else {
//         print("fetchFriends failed with status: ${res.statusCode}");
//       }
//     } catch (e) {
//       print("Error fetchFriends: $e");
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   Future<bool> createGroup({
//     required String name,
//     required String avatarUrl,
//   }) async {
//     try {
//       final token = await TokenService.getAccessToken();
//       final body = jsonEncode({
//         'name': name,
//         'avatar': avatarUrl,
//         'userIds': _selectedUserIds,
//       });
//
//       final res = await http.post(
//         Uri.parse(ApiConfig.createGroup),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: body,
//       );
//
//       return res.statusCode == 200 || res.statusCode == 201;
//     } catch (e) {
//       print("[GROUP] Lỗi tạo nhóm: $e");
//       return false;
//     }
//   }
// }
