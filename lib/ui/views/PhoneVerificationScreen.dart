import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:olachat_mobile/core/utils/constants.dart';
import 'package:olachat_mobile/ui/views/signup_screen.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isOtpSent = false;
  final String baseUrl = "http://localhost:8080/ola-chat";

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) return;

    final res = await http.post(
      Uri.parse('$baseUrl/auth/request-otp'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phoneNumber": phone}),
    );

    if (res.statusCode == 200) {
      setState(() => isOtpSent = true);
      _showSnack("Mã OTP đã gửi về số điện thoại");
    } else {
      _showSnack("Không thể gửi OTP");
    }
  }

  Future<void> verifyOtp() async {
    final phone = phoneController.text.trim();
    final otp = otpController.text.trim();
    if (phone.isEmpty || otp.isEmpty) return;

    final res = await http.post(
      Uri.parse('$baseUrl/auth/verify-otp'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phoneNumber": phone, "otp": otp}),
    );

    if (res.statusCode == 200) {
      _showSnack("Xác thực thành công");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SignUpScreen(phoneNumber: phone),
        ),
      );
    } else {
      _showSnack("OTP không hợp lệ hoặc đã hết hạn");
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
              // Header: Logo + Social
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

              // Nội dung chính
              Expanded(
                flex: 9,
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
                    ),
                    const SizedBox(height: 16),
                    if (isOtpSent)
                      Column(
                        children: [
                          CustomTextField(
                            labelText: "Mã OTP",
                            controller: otpController,
                            isPassword: false,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => isOtpSent ? verifyOtp() : sendOtp(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                          elevation: 0,
                        ),
                        child: Text(
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
  }
}
