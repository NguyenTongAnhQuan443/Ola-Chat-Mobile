import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:olachat_mobile/ui/views/signup_screen.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header_one.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:provider/provider.dart';
import '../../view_models/phone_verification_view_model.dart';
import '../widgets/show_snack_bar.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isOtpSent = false;

  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();
    final phoneVM = context.read<PhoneVerificationViewModel>();

    final success = await phoneVM.sendOtp(phone);
    if (success) {
      setState(() => isOtpSent = true);
      showSuccessSnackBar(context, "Mã OTP đã gửi về số điện thoại");
    } else {
      showErrorSnackBar(context, phoneVM.errorMessage ?? "Không thể gửi OTP");
    }
  }

  Future<void> verifyOtp() async {
    final phone = phoneController.text.trim();
    final otp = otpController.text.trim();
    final phoneVM = context.read<PhoneVerificationViewModel>();

    final success = await phoneVM.verifyOtp(phone, otp);
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SignUpScreen(phoneNumber: phone),
        ),
      );
    } else {
      showErrorSnackBar(context, phoneVM.errorMessage ?? "OTP không hợp lệ hoặc đã hết hạn");
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneVM = context.watch<PhoneVerificationViewModel>();

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
                        AppLogoHeaderOne(showBackButton: true),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/verify_phone.svg',
                                height: 300,
                              ),
                              const SizedBox(height: 30),
                              CustomTextField(
                                labelText: "Số điện thoại",
                                controller: phoneController,
                                isPassword: false,
                                enabled: !isOtpSent,
                              ),
                              const SizedBox(height: 16),
                              if (isOtpSent)
                                Column(
                                  children: [
                                    CustomTextField(
                                      labelText: "Mã OTP",
                                      controller: otpController,
                                      isPassword: false,
                                      enabled: true,
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              SizedBox(
                                width: double.infinity,
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: phoneVM.isLoading
                                      ? null
                                      : () => isOtpSent ? verifyOtp() : sendOtp(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    side: BorderSide(color: Colors.grey.shade300),
                                    elevation: 0,
                                  ),
                                  child: phoneVM.isLoading
                                      ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                      : Text(
                                    isOtpSent ? "Xác minh OTP" : "Gửi mã OTP",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Đã có tài khoản?",
                                      style: TextStyle(fontSize: 14)),
                                  const SizedBox(width: 5),
                                  InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: const Text(
                                      "Đăng nhập",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
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
  }
}
