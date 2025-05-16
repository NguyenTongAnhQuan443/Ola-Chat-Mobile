// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:olachat_mobile/config/api_config.dart';
// import 'package:olachat_mobile/models/login_history_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
//
// class UserSettingInformationLoginHistoryViewModel extends ChangeNotifier {
//   List<LoginHistoryModel> _items = [];
//   bool _isLoading = false;
//   String? _error;
//
//   List<LoginHistoryModel> get items => _items;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//
//   Future<void> fetchHistory(String userId) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('access_token');
//
//       final res = await http.get(
//         Uri.parse(ApiConfig.loginHistory(userId)),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       final jsonData = jsonDecode(utf8.decode(res.bodyBytes));
//
//       if (res.statusCode == 200 && jsonData['success'] == true) {
//         _items = (jsonData['data'] as List)
//             .map((e) => LoginHistoryModel.fromJson(e))
//             .toList();
//       } else {
//         _error = jsonData['message'] ?? 'Đã có lỗi xảy ra';
//       }
//     } catch (e) {
//       _error = "Không thể tải dữ liệu.";
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
// }
