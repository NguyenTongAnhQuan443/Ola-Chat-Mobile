import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Dùng để format ngày
import 'package:olachat_mobile/core/utils/constants.dart';
import 'package:olachat_mobile/ui/views/bottom_navigationbar_screen.dart';
import 'package:olachat_mobile/ui/widgets/custom_social_button.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';

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
  final TextEditingController confirmPasswordController = TextEditingController();

  DateTime? selectedDob;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool isAtLeast18YearsOld(DateTime dob) {
    final now = DateTime.now();
    final age = now.year - dob.year - ((now.month < dob.month || (now.month == dob.month && now.day < dob.day)) ? 1 : 0);
    return age >= 18;
  }

  Future<void> pickDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Chọn ngày sinh',
      locale: const Locale('vi', 'VN'),
    );

    if (picked != null) {
      setState(() => selectedDob = picked);
    }
  }

  Future<void> registerUser() async {
    final displayName = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (displayName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || selectedDob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }

    if (!isAtLeast18YearsOld(selectedDob!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bạn phải đủ 18 tuổi để đăng ký")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mật khẩu nhập lại không khớp")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8080/ola-chat/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone": widget.phoneNumber,
          "username": widget.phoneNumber, // ✅ cùng giá trị
          "password": password,
          "displayName": displayName,
          "email": email,
          "dob": selectedDob!.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng ký thành công")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const BottomNavigationBarScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đăng ký thất bại: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi đăng ký: $e")),
      );
    }
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
                    Text("Social", style: AppStyles.socialTextStyle),
                  ],
                ),
              ),

              // Nội dung
              Expanded(
                flex: 9,
                child: Column(
                  children: [
                    // Social buttons
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

                    // Input fields
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomTextField(
                            labelText: "Họ tên",
                            controller: nameController,
                            isPassword: false,
                          ),
                          CustomTextField(
                            labelText: "Email",
                            controller: emailController,
                            isPassword: false,
                          ),
                          CustomTextField(
                            labelText: "Mật khẩu",
                            controller: passwordController,
                            isPassword: true,
                          ),
                          CustomTextField(
                            labelText: "Nhập lại mật khẩu",
                            controller: confirmPasswordController,
                            isPassword: true,
                          ),
                          InkWell(
                            onTap: pickDateOfBirth,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                selectedDob != null
                                    ? "Ngày sinh: ${dateFormat.format(selectedDob!)}"
                                    : "Chọn ngày sinh",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedDob != null
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Button + quay lại đăng nhập
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
