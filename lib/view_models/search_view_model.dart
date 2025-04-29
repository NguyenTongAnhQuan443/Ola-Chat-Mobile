import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/config/api_config.dart';
import '../data/models/user_response_model.dart';

class SearchViewModel extends ChangeNotifier {
  UserResponseModel? result;
  bool isLoading = false;
  String? error;

  Future<void> searchUser(String query) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        error = 'Không có token. Vui lòng đăng nhập lại.';
        isLoading = false;
        notifyListeners();
        return;
      }

      final url = ApiConfig.searchUser(query);

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final decoded = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decoded);

      if (response.statusCode == 200 && data['data'] != null) {
        result = UserResponseModel.fromJson(data['data']);
      } else {
        error = data['message'] ?? 'Không tìm thấy người dùng';
        result = null;
      }
    } catch (e) {
      error = 'Lỗi kết nối máy chủ';
      result = null;
    }
    finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
