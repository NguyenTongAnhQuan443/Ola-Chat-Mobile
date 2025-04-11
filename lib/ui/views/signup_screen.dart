import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:olachat_mobile/core/utils/constants.dart';
import 'package:olachat_mobile/ui/views/bottom_navigationbar_screen.dart';
import 'package:olachat_mobile/ui/widgets/custom_social_button.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dp;
import 'package:provider/provider.dart';

import '../../view_models/signup_view_model.dart';
import '../widgets/app_logo_header.dart';
import '../widgets/custom_date_picker_field.dart';

class SignUpScreen extends StatefulWidget {
  final String phoneNumber;

  const SignUpScreen({super.key, required this.phoneNumber});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  DateTime? selectedDob;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isAtLeast18YearsOld(DateTime dob) {
    final now = DateTime.now();
    final age = now.year -
        dob.year -
        ((now.month < dob.month ||
                (now.month == dob.month && now.day < dob.day))
            ? 1
            : 0);
    return age >= 18;
  }

  Future<void> pickDateOfBirth() async {
    dp.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900),
      maxTime: DateTime.now(),
      currentTime: selectedDob ?? DateTime(2000),
      locale: dp.LocaleType.vi,
      onConfirm: (date) {
        setState(() => selectedDob = date);
      },
    );
  }

  InputDecoration buildInputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      hintText: label,
      labelStyle: const TextStyle(fontSize: 14),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      suffixIcon: suffixIcon,
    );
  }

  Future<void> registerUser() async {
    final displayName = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (displayName.isEmpty || email.isEmpty || password.isEmpty || selectedDob == null) {
      showSnackbar("Vui lòng nhập đầy đủ thông tin");
      return;
    }

    if (!isAtLeast18YearsOld(selectedDob!)) {
      showSnackbar("Bạn phải đủ 18 tuổi để đăng ký");
      return;
    }

    final data = {
      "username":  widget.phoneNumber,
      "password": password,
      "displayName": displayName,
      "email": email,
      "dob": DateFormat('dd/MM/yyyy').format(selectedDob!),
    };

    final viewModel = context.read<SignUpViewModel>();
    final success = await viewModel.register(data);

    if (success) {
      showSnackbar("Đăng ký thành công");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavigationBarScreen()),
      );
    } else {
      showSnackbar(viewModel.errorMessage ?? "Đăng ký thất bại");
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Expanded(
              //   flex: 1,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       Image.asset('assets/icons/LogoApp.png',
              //           width: AppStyles.logoIconSize,
              //           height: AppStyles.logoIconSize),
              //       const SizedBox(width: 18),
              //       Text("Social", style: AppStyles.socialTextStyle),
              //     ],
              //   ),
              // ),
              AppLogoHeader(showBackButton: true),
              Expanded(
                flex: 9,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(height: 5),
                          CustomSocialButton(
                            iconPath: "assets/icons/Google.png",
                            nameButton: "Đăng ký với Google",
                          ),
                          CustomSocialButton(
                            iconPath: "assets/icons/Email.png",
                            nameButton: "Đăng ký với Facebook",
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(child: _buildDivider()),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text("HOẶC",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey)),
                              ),
                              Expanded(child: _buildDivider()),
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              labelText: "Họ tên",
                              controller: nameController,
                              isPassword: false,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              labelText: "Email",
                              controller: emailController,
                              isPassword: false,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              labelText: "Mật khẩu",
                              controller: passwordController,
                              isPassword: true,
                            ),
                            const SizedBox(height: 12),
                            CustomDatePickerField(
                              labelText: "Ngày sinh",
                              selectedDate: selectedDob,
                              onTap: pickDateOfBirth,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: registerUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: BorderSide(color: Colors.grey.shade300),
                                elevation: 0,
                              ),
                              child: const Text("Đăng ký",
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Bạn đã có tài khoản?",
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
                              )
                            ],
                          ),
                        ],
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

Widget _buildDivider() {
  return Divider(thickness: 1, color: Colors.grey.shade300);
}
