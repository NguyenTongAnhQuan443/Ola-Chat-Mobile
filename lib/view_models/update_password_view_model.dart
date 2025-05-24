import 'package:flutter/material.dart';
import 'package:olachat_mobile/services/user_service.dart';
import 'package:olachat_mobile/ui/widgets/show_snack_bar.dart';

class UpdatePasswordViewModel with ChangeNotifier {
  bool isLoading = false;
  final UserService _userService = UserService();

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
      await _userService.changePassword(oldPassword, newPassword);
      showSuccessSnackBar(context, "Đổi mật khẩu thành công.");
      Navigator.pop(context);
    } catch (e) {
      showErrorSnackBar(context, e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
