import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:olachat_mobile/core/utils/constants.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';
import 'package:olachat_mobile/view_models/update_password_view_model.dart';
import 'package:provider/provider.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UpdatePasswordViewModel(),
      child: Consumer<UpdatePasswordViewModel>(
        builder: (context, vm, _) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.backgroundColor,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    AppLogoHeader(showBackButton: true),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/forgot_password.svg',
                            height: 300,
                          ),
                          const SizedBox(height: 30),
                          CustomTextField(
                            labelText: "Mật khẩu hiện tại",
                            controller: currentPasswordController,
                            isPassword: true,
                            enabled: true,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            labelText: "Mật khẩu mới",
                            controller: newPasswordController,
                            isPassword: true,
                            enabled: true,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            labelText: "Xác nhận mật khẩu mới",
                            controller: confirmPasswordController,
                            isPassword: true,
                            enabled: true,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: vm.isLoading
                                  ? null
                                  : () => vm.changePassword(
                                context,
                                currentPasswordController.text.trim(),
                                newPasswordController.text.trim(),
                                confirmPasswordController.text.trim(),
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
                                  : const Text("Lưu mật khẩu mới", style: TextStyle(fontSize: 14)),
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
