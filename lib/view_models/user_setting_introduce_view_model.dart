import 'package:flutter/material.dart';
import 'package:olachat_mobile/services/user_service.dart';
import 'package:olachat_mobile/ui/widgets/show_snack_bar.dart';
import 'package:provider/provider.dart';
import 'login_view_model.dart';

class UserSettingIntroduceViewModel extends ChangeNotifier {
  final fullNameController = TextEditingController();
  final nicknameController = TextEditingController();
  final bioController = TextEditingController();

  final UserService _userService = UserService();
  bool isLoading = false;

  // Load dữ liệu người dùng từ local (chỉ để show UI ban đầu)
  Future<void> loadInitialData(Map<String, dynamic>? data) async {
    if (data != null) {
      fullNameController.text = data['displayName'] ?? '';
      nicknameController.text = data['nickname'] ?? '';
      bioController.text = data['bio'] ?? '';
      notifyListeners();
    }
  }

  Map<String, dynamic> _buildUpdateData() {
    final Map<String, dynamic> data = {};
    if (fullNameController.text.trim().isNotEmpty) {
      data['displayName'] = fullNameController.text.trim();
    }
    if (nicknameController.text.trim().isNotEmpty) {
      data['nickname'] = nicknameController.text.trim();
    }
    if (bioController.text.trim().isNotEmpty) {
      data['bio'] = bioController.text.trim();
    }
    return data;
  }

  Future<void> updateProfile(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final data = _buildUpdateData();
    if (data.isEmpty) {
      if (context.mounted) {
        showErrorSnackBar(context, "Không có thông tin nào để cập nhật");
      }
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      await _userService.updateProfile(data);

      // Sau khi cập nhật, làm mới dữ liệu user
      await Provider.of<LoginViewModel>(context, listen: false)
          .refreshUserInfo();

      // XÓA nội dung ô input sau khi cập nhật thành công
      fullNameController.clear();
      nicknameController.clear();
      bioController.clear();

      if (context.mounted) {
        showSuccessSnackBar(context, "Cập nhật thông tin thành công");
      }
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(context, "Lỗi khi cập nhật: $e");
      }
    }

    isLoading = false;
    notifyListeners();
  }
}
