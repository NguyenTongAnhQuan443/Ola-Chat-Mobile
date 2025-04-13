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

  /// ✅ Load dữ liệu người dùng từ SharedPreferences
  Future<void> loadInitialData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userInfo = prefs.getString('user_info');
      if (userInfo != null) {
        final data = Map<String, dynamic>.from(jsonDecode(userInfo));
        fullNameController.text = data['displayName'] ?? '';
        nicknameController.text = data['nickname'] ?? '';
        bioController.text = data['bio'] ?? '';
      }
    } catch (e) {
      debugPrint("Lỗi khi load dữ liệu ban đầu: $e");
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
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(context, "Lỗi khi gọi API cập nhật: $e");
      }
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final loginVM = Provider.of<LoginViewModel>(context, listen: false);
      await loginVM.refreshUserInfo();
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(context, "Lỗi khi làm mới dữ liệu: $e");
      }
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final userInfo = prefs.getString('user_info');
      if (userInfo != null) {
        final decoded = Map<String, dynamic>.from(jsonDecode(userInfo));
        data.forEach((key, value) {
          decoded[key] = value;
        });
        await prefs.setString('user_info', jsonEncode(decoded));
      }
      await loadInitialData();
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(context, "Lỗi khi cập nhật bộ nhớ cục bộ: $e");
      }
    }

    if (context.mounted) {
      showSuccessSnackBar(context, "Cập nhật thông tin thành công");
    }

    isLoading = false;
    notifyListeners();
  }
}
