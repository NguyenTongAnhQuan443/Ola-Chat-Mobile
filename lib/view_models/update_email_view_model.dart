import 'package:flutter/material.dart';
import 'package:olachat_mobile/services/user_service.dart';
import 'package:provider/provider.dart';
import '../ui/widgets/show_snack_bar.dart';
import 'login_view_model.dart';

class UpdateEmailViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  bool isLoading = false;
  bool isOtpSent = false;

  /// Kiểm tra định dạng email hợp lệ (mọi domain)
  bool _isValidEmail(String email) {
    final regex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return regex.hasMatch(email);
  }

  /// Gửi OTP đến email
  Future<void> sendOtp(BuildContext context, String newEmail) async {
    if (!_isValidEmail(newEmail)) {
      showErrorSnackBar(context, "Email không hợp lệ. Vui lòng nhập đúng định dạng email.");
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      await _userService.sendEmailOtp(newEmail);
      isOtpSent = true;
      showSuccessSnackBar(context, "Đã gửi mã OTP đến email.");
    } catch (e) {
      showErrorSnackBar(context, "Lỗi: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Xác minh OTP để cập nhật email
  Future<void> verifyOtp(BuildContext context, String otp) async {
    if (otp.trim().isEmpty) {
      showErrorSnackBar(context, "Vui lòng nhập mã OTP.");
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      await _userService.verifyEmailOtp(otp);

      // Làm mới userInfo
      await Provider.of<LoginViewModel>(context, listen: false).refreshUserInfo();

      showSuccessSnackBar(context, "Cập nhật email thành công!");
      Navigator.pop(context); // Quay lại
    } catch (e) {
      showErrorSnackBar(context, "Lỗi: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
