import 'package:flutter/material.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/services/socket_service.dart';
import 'package:olachat_mobile/services/token_service.dart';
import 'package:olachat_mobile/ui/views/phone_verification_screen.dart';
import 'package:olachat_mobile/ui/widgets/custom_social_button.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:olachat_mobile/view_models/socket_view_model.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../view_models/login_view_model.dart';
import '../widgets/app_logo_header_one.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/show_snack_bar.dart';
import 'bottom_navigationbar_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController hostController =
      TextEditingController(text: ApiConfig.host);

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    hostController.dispose();
    super.dispose();
  }

  Future<void> _handleSocialLogin(Future<void> Function() loginMethod) async {
    final context = navigatorKey.currentContext!;
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    await loginMethod();

    final auth = viewModel.authResponse;

    if (auth != null) {
      await handleAfterLoginSuccess(context, auth.accessToken);
    } else {
      showErrorSnackBar(context, viewModel.errorMessage ?? 'Có lỗi xảy ra');
    }
  }

  Future<void> _handleLogin() async {
    final context = navigatorKey.currentContext!;
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    final phoneRegex = RegExp(r'^0\d{9}$');
    if (!phoneRegex.hasMatch(phone)) {
      showErrorSnackBar(context,
          'Số điện thoại không hợp lệ. Vui lòng nhập 10 số bắt đầu bằng số 0.');
      return;
    }
    if (password.isEmpty) {
      showErrorSnackBar(context, 'Vui lòng nhập mật khẩu.');
      return;
    }

    await viewModel.loginWithPhone(phone, password);
    final auth = viewModel.authResponse;

    if (auth != null) {
      await handleAfterLoginSuccess(context, auth.accessToken);
    } else {
      showErrorSnackBar(context, viewModel.errorMessage ?? 'Có lỗi xảy ra');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppStyles.backgroundColor,
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(height: 5),
                                    CustomSocialButton(
                                      iconPath: "assets/icons/Google.png",
                                      nameButton: "Đăng nhập với Google",
                                      onPressed: viewModel.isLoading
                                          ? null
                                          : () => _handleSocialLogin(() async {
                                                await Provider.of<
                                                            LoginViewModel>(
                                                        navigatorKey
                                                            .currentContext!,
                                                        listen: false)
                                                    .loginWithGoogle();
                                              }),
                                    ),
                                    CustomSocialButton(
                                      iconPath: "assets/icons/Facebook.png",
                                      nameButton: "Đăng nhập với Facebook",
                                      onPressed: viewModel.isLoading
                                          ? null
                                          : () => _handleSocialLogin(() async {
                                                await Provider.of<
                                                            LoginViewModel>(
                                                        navigatorKey
                                                            .currentContext!,
                                                        listen: false)
                                                    .loginWithFacebook();
                                              }),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Divider(
                                              thickness: 1,
                                              color: Colors.grey.shade300),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text("OR",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey)),
                                        ),
                                        Expanded(
                                          child: Divider(
                                              thickness: 1,
                                              color: Colors.grey.shade300),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomTextField(
                                      labelText: "Số điện thoại",
                                      controller: phoneController,
                                      isPassword: false,
                                      enabled: true,
                                    ),
                                    CustomTextField(
                                      labelText: "Mật khẩu",
                                      controller: passwordController,
                                      isPassword: true,
                                      enabled: true,
                                    ),
                                    CustomTextField(
                                      labelText:
                                          "Host (ví dụ: http://192.168.1.4:8080)",
                                      controller: hostController,
                                      isPassword: false,
                                      enabled: true,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        // onTap: () {
                                        //   Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             const ForgotPasswordScreen()),
                                        //   );
                                        // },
                                        child: const Text("Quên mật khẩu ?",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
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
                                      child: ElevatedButton(
                                        onPressed: viewModel.isLoading
                                            ? null
                                            : () => _handleLogin(),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          side: BorderSide(
                                              color: Colors.grey.shade300),
                                          elevation: 0,
                                        ),
                                        child: viewModel.isLoading
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                ),
                                              )
                                            : const Text("Đăng nhập",
                                                style: TextStyle(fontSize: 14)),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Bạn chưa có tài khoản?",
                                            style: TextStyle(fontSize: 14)),
                                        const SizedBox(width: 5),
                                        InkWell(
                                          // onTap: () {
                                          //   Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             PhoneVerificationScreen()),
                                          //   );
                                          // },
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
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> handleAfterLoginSuccess(
      BuildContext context, String accessToken) async {
    if (accessToken.isNotEmpty) {
      final socketVM = Provider.of<SocketViewModel>(context, listen: false);
      socketVM.initSocketConnection(accessToken);
    }

    Future.microtask(() {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (_) => const BottomNavigationBarScreen()),
      );
    });
  }
}
