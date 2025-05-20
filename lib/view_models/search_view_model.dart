import 'package:flutter/material.dart';
import 'package:olachat_mobile/models/user_response_model.dart';
import 'package:olachat_mobile/services/token_service.dart';
import 'package:olachat_mobile/services/user_service.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

class SearchViewModel extends ChangeNotifier {
  UserResponseModel? result;
  bool isLoading = false;
  String? error;

  Future<void> searchUser(String query) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await TokenService.getAccessToken();
      if (token == null) throw Exception('Token không tồn tại');

      result = await UserService.search(query, token);
      if (result == null) {
        error = "Không tìm thấy người dùng.";
      }
    } catch (e) {
      debugPrint('${AppStyles.failureIcon}Lỗi searchUser: $e');
      error = 'Lỗi kết nối máy chủ';
      result = null;
    } finally {
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
