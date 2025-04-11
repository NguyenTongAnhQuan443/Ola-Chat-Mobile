import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/widgets/show_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/services/User_service.dart';
import 'login_view_model.dart';

class AccountSettingsViewModel extends ChangeNotifier {
  final fullNameController = TextEditingController();
  final nicknameController = TextEditingController();
  final bioController = TextEditingController();

  final UserService _userService = UserService();
  bool isLoading = false;

  void loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfo = prefs.getString('user_info');
    if (userInfo != null) {
      final data = Map<String, dynamic>.from(
          jsonDecode(utf8.decode(userInfo.codeUnits)));
      fullNameController.text = data['displayName'] ?? '';
      nicknameController.text = data['nickname'] ?? '';
      bioController.text = data['bio'] ?? '';
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

    try {
      final data = _buildUpdateData();
      if (data.isEmpty) {
        showErrorSnackBar(context, "Không có thông tin nào để cập nhật");
        isLoading = false;
        notifyListeners();
        return;
      }

      await _userService.updateProfile(data);
      // Sau khi cập nhật thành công:
      showSuccessSnackBar(context, "Cập nhật thông tin thành công");

      // Làm mới user info trên ProfileScreen
      final loginVM = Provider.of<LoginViewModel>(context, listen: false);
      await loginVM.refreshUserInfo();

      //  Xóa nội dung trong các ô input
      fullNameController.clear();
      nicknameController.clear();
      bioController.clear();

      final prefs = await SharedPreferences.getInstance();
      final userInfo = prefs.getString('user_info');
      if (userInfo != null) {
        final decoded = Map<String, dynamic>.from(
            jsonDecode(utf8.decode(userInfo.codeUnits)));
        data.forEach((key, value) {
          decoded[key] = value;
        });
        prefs.setString('user_info', jsonEncode(decoded));
      }
    } catch (e) {
      showErrorSnackBar(context, "Cập nhật thất bại");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
