import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/config/api_config.dart';
import '../data/models/user_response_model.dart';
import '../data/services/user_service.dart';

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
      if (token == null) throw Exception('Token không tồn tại');

      result = await UserService.search(query, token);
    } catch (e, stackTrace) {
      debugPrint('Lỗi searchUser: $e');
      debugPrint('Stack trace: $stackTrace');
      error = 'Lỗi kết nối máy chủ';
      result = null;
    }
    finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearSearchResult() {
    result = null;
    error = null;
    isLoading = false;
    notifyListeners();
  }

}
