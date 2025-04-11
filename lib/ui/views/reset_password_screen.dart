import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:olachat_mobile/core/utils/constants.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';
import 'package:olachat_mobile/view_models/reset_password_view_model.dart';
import 'package:provider/provider.dart';
import '../widgets/show_snack_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ResetPasswordViewModel>(context);

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
                        onPressed: viewModel.isLoading
                            ? null
                            : () {
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

                          if (!viewModel.isValidPassword(newPass)) {
                            showErrorSnackBar(
                                context,
                                'Mật khẩu phải có ít nhất 8 ký tự, 1 chữ cái viết hoa, 1 số và 1 ký tự đặc biệt.');
                            return;
                          }

                          viewModel.resetPassword(
                            widget.email,
                            otp,
                            newPass,
                            context,
                          );
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
                            : const Text("Đổi mật khẩu", style: TextStyle(fontSize: 14)),
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
