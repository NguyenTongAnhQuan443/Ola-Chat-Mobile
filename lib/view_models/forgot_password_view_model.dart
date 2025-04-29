import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:olachat_mobile/core/utils/config/api_config.dart';
import 'package:olachat_mobile/ui/views/reset_password_screen.dart';
import '../ui/widgets/show_snack_bar.dart';

class ForgotPasswordViewModel with ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<void> sendOtp(String email, BuildContext context, {VoidCallback? onSuccess}) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.authForgotPassword}?email=$email"),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        onSuccess?.call();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ResetPasswordScreen(email: email)),
        );
      } else {
        errorMessage = data['message'] ?? "Có lỗi xảy ra.";
        showErrorSnackBar(context, errorMessage!);
      }
    } catch (e) {
      errorMessage = e.toString();
      showErrorSnackBar(context, "Lỗi gửi OTP: $errorMessage");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
