import 'dart:io';
import 'package:flutter/material.dart';
import 'package:olachat_mobile/services/user_service.dart';
import 'package:olachat_mobile/ui/widgets/show_snack_bar.dart';
import 'package:olachat_mobile/view_models/login_view_model.dart';
import 'package:provider/provider.dart';

class UserSettingAvatarViewModel extends ChangeNotifier {
  File? selectedImage;
  bool isLoading = false;

  void selectImage(File image) {
    selectedImage = image;
    notifyListeners();
  }

  Future<void> updateAvatar(BuildContext context) async {
    if (selectedImage == null) {
      showErrorSnackBar(context, "Vui lòng chọn ảnh trước khi cập nhật.");
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      await UserService().uploadAvatar(selectedImage!);

      // Làm mới dữ liệu user từ LoginViewModel
      await Provider.of<LoginViewModel>(context, listen: false)
          .refreshUserInfo();

      selectedImage = null; // Reset hình đã chọn
      showSuccessSnackBar(context, "Cập nhật ảnh đại diện thành công");
    } catch (e) {
      showErrorSnackBar(context, "Có lỗi xảy ra: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
