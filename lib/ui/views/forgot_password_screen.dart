import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:olachat_mobile/core/utils/constants.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';
import 'package:olachat_mobile/view_models/forgot_password_view_model.dart';
import 'package:provider/provider.dart';
import '../widgets/app_logo_header.dart';
import '../widgets/show_snack_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ForgotPasswordViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppLogoHeader(showBackButton: true),
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
                    CustomTextField(
                      labelText: "Địa chỉ email",
                      controller: emailController,
                      isPassword: false,
                      enabled: true,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () {
                                final email = emailController.text.trim();
                                if (!email.contains('@') ||
                                    !email.contains('.')) {
                                  showErrorSnackBar(context,
                                      "Vui lòng nhập địa chỉ email hợp lệ.");
                                  return;
                                }
                                viewModel.sendOtp(email, context,
                                    onSuccess: () {
                                  showSuccessSnackBar(
                                      context, "Đã gửi mã OTP đến $email");
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                          elevation: 0,
                        ),
                        child: viewModel.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text("Gửi mã xác nhận",
                                style: TextStyle(fontSize: 14)),
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
                          color: Colors.black,
                        ),
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
