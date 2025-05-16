import 'package:flutter/material.dart';
import 'package:olachat_mobile/services/reset_password_service.dart';
import '../ui/views/login_screen.dart';
import '../ui/widgets/show_snack_bar.dart';

class ResetPasswordViewModel with ChangeNotifier {
  final ResetPasswordService _service = ResetPasswordService();
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
      await _service.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      showSuccessSnackBar(context, "Đổi mật khẩu thành công.");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      error = e.toString();
      showErrorSnackBar(context, error ?? 'Lỗi không xác định');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
