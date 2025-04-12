import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:olachat_mobile/core/config/api_config.dart';
import 'package:olachat_mobile/ui/widgets/show_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_view_model.dart';
import 'package:provider/provider.dart';

class UpdateEmailViewModel extends ChangeNotifier {
  bool isLoading = false;
  bool otpSent = false;       // Đã gửi OTP cho email hiện tại
  bool newOtpSent = false;    // Đã gửi OTP cho email mới

  /// Gửi OTP đến email hiện tại
  Future<void> sendOtpToCurrentEmail(String currentEmail, BuildContext context) async {
    if (currentEmail.isEmpty) {
      showErrorSnackBar(context, "Vui lòng nhập email hiện tại");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("ApiConfig.authSendOtp"), // endpoint gửi OTP
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": currentEmail}),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200 && data['success'] == true) {
        showSuccessSnackBar(context, "Đã gửi mã OTP đến email hiện tại");
        otpSent = true;
      } else {
        showErrorSnackBar(context, data['message'] ?? "Không gửi được mã OTP");
      }
    } catch (e) {
      showErrorSnackBar(context, "Lỗi khi gửi OTP: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Gửi OTP đến email mới
  Future<void> sendOtpToNewEmail(String newEmail, BuildContext context) async {
    if (newEmail.isEmpty) {
      showErrorSnackBar(context, "Vui lòng nhập email mới");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("ApiConfig.authSendOtp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": newEmail}),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200 && data['success'] == true) {
        showSuccessSnackBar(context, "Đã gửi mã OTP đến email mới");
        newOtpSent = true;
      } else {
        showErrorSnackBar(context, data['message'] ?? "Không gửi được mã OTP");
      }
    } catch (e) {
      showErrorSnackBar(context, "Lỗi khi gửi OTP: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Xác thực cả 2 OTP và cập nhật email
  Future<void> verifyAllOtpsAndUpdateEmail(
      BuildContext context,
      String currentEmail,
      String currentOtp,
      String newEmail,
      String newOtp,
      ) async {
    if (currentEmail.isEmpty ||
        currentOtp.isEmpty ||
        newEmail.isEmpty ||
        newOtp.isEmpty) {
      showErrorSnackBar(context, "Vui lòng nhập đầy đủ thông tin.");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final response = await http.post(
        Uri.parse("ApiConfig.authVerifyEmailOtp"), // endpoint cập nhật email
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "oldEmail": currentEmail,
          "oldEmailOtp": currentOtp,
          "newEmail": newEmail,
          "newEmailOtp": newOtp,
        }),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && data['success'] == true) {
        showSuccessSnackBar(context, "Cập nhật email thành công");
        await Provider.of<LoginViewModel>(context, listen: false).refreshUserInfo();
        Navigator.pop(context);
      } else {
        showErrorSnackBar(context, data['message'] ?? "Cập nhật email thất bại");
      }
    } catch (e) {
      showErrorSnackBar(context, "Lỗi cập nhật email: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
