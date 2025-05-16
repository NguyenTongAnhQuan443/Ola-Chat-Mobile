import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:olachat_mobile/ui/views/bottom_navigationbar_screen.dart';
import 'package:olachat_mobile/ui/widgets/custom_social_button.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
as dp;
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:provider/provider.dart';

import '../../view_models/signup_view_model.dart';
import '../widgets/app_logo_header_one.dart';
import '../widgets/custom_date_picker_field.dart';
import '../widgets/show_snack_bar.dart';
import 'login_screen.dart';

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
  bool isLoading = false;

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

  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$')
        .hasMatch(password);
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

    if (displayName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        selectedDob == null) {
      showErrorSnackBar(context, "Vui lòng nhập đầy đủ thông tin");
      return;
    }

    if (!isAtLeast18YearsOld(selectedDob!)) {
      showErrorSnackBar(context, "Bạn phải đủ 18 tuổi để đăng ký");
      return;
    }

    if (!isValidPassword(password)) {
      showErrorSnackBar(context,
          "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ thường, chữ hoa, số và ký tự đặc biệt.");
      return;
    }

    setState(() => isLoading = true);

    final data = {
      "username": widget.phoneNumber,
      "password": password,
      "displayName": displayName,
      "email": email,
      "dob": DateFormat('dd/MM/yyyy').format(selectedDob!),
    };

    final viewModel = context.read<SignUpViewModel>();
    final success = await viewModel.register(data);

    setState(() => isLoading = false);

    if (success) {
      showSuccessSnackBar(context, "Đăng ký thành công");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      showErrorSnackBar(context, viewModel.errorMessage ?? "Đăng ký thất bại");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppStyles.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppLogoHeaderOne(showBackButton: false),
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
                              enabled: true,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              labelText: "Email",
                              controller: emailController,
                              isPassword: false,
                              enabled: true,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              labelText: "Mật khẩu",
                              controller: passwordController,
                              isPassword: true,
                              enabled: true,
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
                              onPressed: isLoading ? null : registerUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: BorderSide(color: Colors.grey.shade300),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                                  : const Text("Đăng ký",
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
