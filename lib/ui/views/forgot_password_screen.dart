import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/views/reset_password_screen.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';
import 'package:olachat_mobile/core/utils/constants.dart';
import 'package:olachat_mobile/ui/widgets/show_snack_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  Future<void> sendOtpToEmail() async {
    // final email = emailController.text.trim();
    //
    // if (!email.contains('@') || !email.contains('.')) {
    //   showErrorSnackBar(context, "Vui lòng nhập địa chỉ email hợp lệ.");
    //   return;
    // }
    //
    // // TODO: gọi API gửi OTP đến email tại đây
    // showSuccessSnackBar(context, "Đã gửi OTP đến email $email");
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ResetPasswordScreen(email: "email"),
    ));

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
              // Header
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

              // Body
              Expanded(
                flex: 9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/forgot_password.svg',
                      height: 300,
                    ),
                    const SizedBox(height: 30),

                    // Nhập email
                    CustomTextField(
                      labelText: "Địa chỉ email",
                      controller: emailController,
                      isPassword: false,
                    ),
                    const SizedBox(height: 16),

                    // Gửi mã
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: sendOtpToEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                          elevation: 0,
                        ),
                        child: const Text("Gửi mã xác nhận", style: TextStyle(fontSize: 14)),
                      ),
                    ),

                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Quay lại đăng nhập",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
