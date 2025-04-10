import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:olachat_mobile/core/utils/constants.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';
import '../../core/config/api_config.dart';
import '../widgets/show_snack_bar.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> resetPassword() async {
    final otp = otpController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (otp.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      showErrorSnackBar(context, 'Vui lòng điền đầy đủ thông tin.');
      return;
    }

    if (newPass != confirmPass) {
      showErrorSnackBar(context, 'Mật khẩu nhập lại không khớp.');
      return;
    }

    try {
      final res = await http.post(
        Uri.parse("ApiConfig.resetPassword"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "otp": otp,
          "newPassword": newPass
        }),
      );

      final data = jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode == 200 && data['success'] == true) {
        showSuccessSnackBar(context, 'Đặt lại mật khẩu thành công.');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        showErrorSnackBar(context, data['message'] ?? 'OTP không hợp lệ.');
      }
    } catch (e) {
      showErrorSnackBar(context, 'Lỗi đổi mật khẩu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset('assets/icons/LogoApp.png',
                        width: AppStyles.logoIconSize,
                        height: AppStyles.logoIconSize),
                    const SizedBox(width: 18),
                    const Text("Social", style: AppStyles.socialTextStyle),
                  ],
                ),
              ),
              Expanded(
                flex: 9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/confirmed.svg',
                      height: 280,
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      labelText: "Mã OTP",
                      controller: otpController,
                      isPassword: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      labelText: "Mật khẩu mới",
                      controller: newPasswordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      labelText: "Nhập lại mật khẩu",
                      controller: confirmPasswordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                          elevation: 0,
                        ),
                        child: const Text("Đổi mật khẩu", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}