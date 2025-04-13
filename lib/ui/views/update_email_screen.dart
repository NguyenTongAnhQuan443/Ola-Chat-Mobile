import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:olachat_mobile/core/utils/constants.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';
import 'package:olachat_mobile/view_models/update_email_view_model.dart';
import 'package:provider/provider.dart';

class UpdateEmailScreen extends StatefulWidget {
  const UpdateEmailScreen({super.key});

  @override
  State<UpdateEmailScreen> createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UpdateEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UpdateEmailViewModel(),
      child: Consumer<UpdateEmailViewModel>(
        builder: (context, vm, _) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.backgroundColor,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    AppLogoHeader(showBackButton: false),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/email.svg',
                            height: 300,
                          ),
                          const SizedBox(height: 30),
                          CustomTextField(
                            labelText: "Email mới",
                            controller: emailController,
                            enabled: !vm.isOtpSent, isPassword: false,
                          ),
                          const SizedBox(height: 16),
                          if (vm.isOtpSent)
                            CustomTextField(
                              labelText: "Nhập mã OTP",
                              controller: otpController, isPassword: false,
                            ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: vm.isLoading
                                  ? null
                                  : vm.isOtpSent
                                  ? () => vm.verifyOtp(
                                context,
                                otpController.text.trim(),
                              )
                                  : () => vm.sendOtp(
                                context,
                                emailController.text.trim(),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: vm.isLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                                  : Text(vm.isOtpSent
                                  ? "Cập nhật email"
                                  : "Gửi mã xác thực"),
                            ),
                          ),
                          const SizedBox(height: 30),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              "Quay lại",
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
        },
      ),
    );
  }
}
