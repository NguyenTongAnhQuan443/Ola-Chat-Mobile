import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:olachat_mobile/core/config/api_config.dart';
import 'package:olachat_mobile/ui/widgets/show_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePasswordViewModel with ChangeNotifier {
  bool isLoading = false;

  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$')
        .hasMatch(password);
  }

  Future<void> changePassword(
      BuildContext context,
      String oldPassword,
      String newPassword,
      String confirmPassword,
      ) async {
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      showErrorSnackBar(context, "Vui lòng nhập đầy đủ thông tin.");
      return;
    }

    if (newPassword != confirmPassword) {
      showErrorSnackBar(context, "Xác nhận mật khẩu không khớp.");
      return;
    }

    if (!isValidPassword(newPassword)) {
      showErrorSnackBar(context,
          "Mật khẩu phải có ít nhất 8 ký tự, 1 chữ cái viết hoa, 1 số và 1 ký tự đặc biệt.");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final uri = Uri.parse(ApiConfig.changePassword);

      final response = await http.put(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && data['success'] == true) {
        showSuccessSnackBar(context, "Đổi mật khẩu thành công.");
        Navigator.pop(context);
      } else {
        showErrorSnackBar(context, data['message'] ?? "Đổi mật khẩu thất bại.");
      }
    } catch (e) {
      showErrorSnackBar(context, e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
