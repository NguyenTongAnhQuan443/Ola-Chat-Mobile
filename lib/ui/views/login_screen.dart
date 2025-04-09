import 'package:flutter/material.dart';
import 'package:olachat_mobile/core/utils/constants.dart';
import 'package:olachat_mobile/ui/views/signup_screen.dart';
import 'package:olachat_mobile/ui/widgets/custom_social_button.dart';
import 'package:provider/provider.dart';
import '../../view_models/login_view_model.dart';
import '../widgets/custom_textfield.dart';
import 'bottom_navigationbar_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSocialLogin(
      BuildContext context, Future<void> Function() loginMethod) async {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    await loginMethod();

    if (viewModel.authResponse != null) {
      print("Đăng nhập thành công! Token: ${viewModel.authResponse!.token}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavigationBarScreen()),
      );
    } else {
      _showLoginErrorDialog(context, viewModel.errorMessage ?? "Có lỗi xảy ra");
    }
  }

  _showLoginErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Đăng nhập thất bại",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text(message,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Thử lại",
                      style: TextStyle(color: Colors.blue, fontSize: 16)),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(height: 5),
                          CustomSocialButton(
                            iconPath: "assets/icons/Google.png",
                            nameButton: "Đăng nhập với Google",
                            onPressed: () =>
                                _handleSocialLogin(context, () async {
                              await Provider.of<LoginViewModel>(context,
                                      listen: false)
                                  .loginWithGoogle();
                            }),
                          ),
                          CustomSocialButton(
                            iconPath: "assets/icons/Facebook.png",
                            nameButton: "Đăng nhập với Facebook",
                            onPressed: () =>
                                _handleSocialLogin(context, () async {
                              await Provider.of<LoginViewModel>(context,
                                      listen: false)
                                  .loginWithFacebook();
                            }),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                    thickness: 1, color: Colors.grey.shade300),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text("OR",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey)),
                              ),
                              Expanded(
                                child: Divider(
                                    thickness: 1, color: Colors.grey.shade300),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomTextField(
                              labelText: "Số điện thoại",
                              controller: phoneController,
                              isPassword: false),
                          CustomTextField(
                              labelText: "Mật khẩu",
                              controller: passwordController,
                              isPassword: true),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {},
                              child: const Text("Quên mật khẩu?",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
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
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final viewModel = Provider.of<LoginViewModel>(context, listen: false);
                                await viewModel.loginWithPhone(
                                  phoneController.text.trim(),
                                  passwordController.text.trim(),
                                );

                                if (viewModel.authResponse != null) {
                                  print('Đăng nhập số điện thoại thành công: ${viewModel.authResponse!.token}');

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const BottomNavigationBarScreen()),
                                  );
                                } else {
                                  _showLoginErrorDialog(context, viewModel.errorMessage ?? 'Có lỗi xảy ra');
                                }
                              },

                              label: const Text("Đăng nhập",
                                  style: TextStyle(fontSize: 14)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: BorderSide(color: Colors.grey.shade300),
                                elevation: 0,
                              ),
                              icon: const SizedBox(),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Bạn chưa có tài khoản?",
                                  style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 5),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen()),
                                  );
                                },
                                child: const Text("Đăng ký",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
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
