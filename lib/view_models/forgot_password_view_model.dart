import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/services/forgot_password_service.dart';
import 'package:olachat_mobile/ui/views/reset_password_screen.dart';
import '../ui/widgets/show_snack_bar.dart';

class ForgotPasswordViewModel with ChangeNotifier {
  final ForgotPasswordService _service = ForgotPasswordService();

  bool isLoading = false;
  String? errorMessage;

  Future<void> sendOtp(String email, BuildContext context, {VoidCallback? onSuccess}) async {
    isLoading = true;
    notifyListeners();

    try {
      await _service.sendOtp(email);
      onSuccess?.call();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResetPasswordScreen(email: email)),
      );
    } catch (e) {
      errorMessage = e.toString();
      showErrorSnackBar(context, errorMessage ?? 'Gửi OTP thất bại');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
