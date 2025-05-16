import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:olachat_mobile/view_models/forgot_password_view_model.dart';
import 'package:provider/provider.dart';
import '../widgets/app_logo_header_one.dart';
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
        backgroundColor: AppStyles.backgroundColor,
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const AppLogoHeaderOne(showBackButton: false),
                      const SizedBox(height: 140),
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
                            if (!email.contains('@') || !email.contains('.')) {
                              showErrorSnackBar(context, "Vui lòng nhập địa chỉ email hợp lệ.");
                              return;
                            }
                            viewModel.sendOtp(email, context, onSuccess: () {
                              showSuccessSnackBar(context, "Đã gửi mã OTP đến $email");
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
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : const Text("Gửi mã xác nhận", style: TextStyle(fontSize: 14)),
                        ),
                      ),
                      // const Spacer(), // đẩy phần quay lại xuống dưới cùng
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
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}
