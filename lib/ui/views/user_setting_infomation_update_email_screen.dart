import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header_one.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:olachat_mobile/view_models/update_email_view_model.dart';
import 'package:provider/provider.dart';

class UserSettingInfomationUpdateEmailScreen extends StatefulWidget {
  const UserSettingInfomationUpdateEmailScreen({super.key});

  @override
  State<UserSettingInfomationUpdateEmailScreen> createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UserSettingInfomationUpdateEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UpdateEmailViewModel(),
      child: Consumer<UpdateEmailViewModel>(
        builder: (context, vm, _) {
          return SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: AppStyles.backgroundColor,
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              AppLogoHeaderOne(showBackButton: false),
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
                                      enabled: !vm.isOtpSent,
                                      isPassword: false,
                                    ),
                                    const SizedBox(height: 16),
                                    if (vm.isOtpSent)
                                      CustomTextField(
                                        labelText: "Nhập mã OTP",
                                        controller: otpController,
                                        isPassword: false,
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
                                            : Text(
                                          vm.isOtpSent
                                              ? "Cập nhật email"
                                              : "Gửi mã xác thực",
                                        ),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
