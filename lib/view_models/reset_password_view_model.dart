import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/config/api_config.dart';
import '../ui/views/login_screen.dart';
import '../ui/widgets/show_snack_bar.dart';
class ResetPasswordViewModel with ChangeNotifier {
  bool isLoading = false;
  String? error;

  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$')
        .hasMatch(password);
  }

  Future<void> resetPassword(
      String email, String otp, String newPassword, BuildContext context) async {
    error = null;
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.authResetPassword),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
          "newPassword": newPassword,
        }),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && data['success'] == true) {
        showSuccessSnackBar(context, "Đổi mật khẩu thành công.");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        error = data['message'];
        showErrorSnackBar(context, error ?? "Thất bại.");
      }
    } catch (e) {
      error = e.toString();
      showErrorSnackBar(context, error!);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
