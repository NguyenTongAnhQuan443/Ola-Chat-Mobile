import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:olachat_mobile/core/utils/constants.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import '../../view_models/update_email_view_model.dart';

class UpdateEmailScreen extends StatefulWidget {
  const UpdateEmailScreen({super.key});

  @override
  State<UpdateEmailScreen> createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UpdateEmailScreen> {
  final TextEditingController currentEmailController = TextEditingController();
  final TextEditingController currentOtpController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController newOtpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UpdateEmailViewModel(),
      child: Consumer<UpdateEmailViewModel>(
        builder: (context, vm, _) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.backgroundColor,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppLogoHeader(showBackButton: true),
                    Expanded(
                      flex: 9,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/forgot_password.svg',
                              height: 220,
                            ),
                            const SizedBox(height: 20),

                            /// Email hiện tại
                            CustomTextField(
                              labelText: "Email hiện tại",
                              controller: currentEmailController,
                              isPassword: false,
                              enabled: !vm.otpSent,
                            ),
                            const SizedBox(height: 12),

                            /// OTP xác nhận email hiện tại
                            if (vm.otpSent)
                              CustomTextField(
                                labelText: "Mã OTP (Email hiện tại)",
                                controller: currentOtpController,
                                isPassword: false,
                                enabled: true,
                              ),
                            const SizedBox(height: 12),

                            /// Email mới
                            if (vm.otpSent)
                              CustomTextField(
                                labelText: "Email mới",
                                controller: newEmailController,
                                isPassword: false,
                                enabled: !vm.newOtpSent,
                              ),
                            const SizedBox(height: 12),

                            /// OTP xác nhận email mới
                            if (vm.otpSent && vm.newOtpSent)
                              CustomTextField(
                                labelText: "Mã OTP (Email mới)",
                                controller: newOtpController,
                                isPassword: false,
                                enabled: true,
                              ),
                            const SizedBox(height: 16),

                            /// Buttons
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: vm.isLoading
                                      ? null
                                      : () => vm.sendOtpToCurrentEmail(
                                    currentEmailController.text.trim(),
                                    context,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade800,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Gửi mã OTP (Email hiện tại)",
                                      style: TextStyle(fontSize: 14)),
                                ),
                                const SizedBox(height: 10),
                                if (vm.otpSent)
                                  ElevatedButton(
                                    onPressed: vm.isLoading
                                        ? null
                                        : () => vm.sendOtpToNewEmail(
                                      newEmailController.text.trim(),
                                      context,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade800,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text("Gửi mã OTP (Email mới)",
                                        style: TextStyle(fontSize: 14)),
                                  ),
                                const SizedBox(height: 10),
                                if (vm.otpSent && vm.newOtpSent)
                                  ElevatedButton(
                                    onPressed: vm.isLoading
                                        ? null
                                        : () => vm.verifyAllOtpsAndUpdateEmail(
                                      context,
                                      currentEmailController.text.trim(),
                                      currentOtpController.text.trim(),
                                      newEmailController.text.trim(),
                                      newOtpController.text.trim(),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: vm.isLoading
                                        ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                        : const Text("Xác nhận thay đổi Email",
                                        style: TextStyle(fontSize: 14)),
                                  ),
                              ],
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
