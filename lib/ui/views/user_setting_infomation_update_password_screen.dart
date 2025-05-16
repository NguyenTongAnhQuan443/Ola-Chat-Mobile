import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header_one.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:olachat_mobile/view_models/update_password_view_model.dart';
import 'package:provider/provider.dart';

class UserSettingInfomationUpdatePasswordScreen extends StatefulWidget {
  const UserSettingInfomationUpdatePasswordScreen({super.key});

  @override
  State<UserSettingInfomationUpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UserSettingInfomationUpdatePasswordScreen> {
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
                                      'assets/images/access_account.svg',
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
