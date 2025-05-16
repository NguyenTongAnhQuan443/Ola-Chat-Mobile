// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';
// import 'package:olachat_mobile/utils/app_styles.dart';
// import 'package:olachat_mobile/view_models/reset_password_view_model.dart';
// import 'package:provider/provider.dart';
// import '../widgets/app_logo_header_one.dart';
// import '../widgets/show_snack_bar.dart';
//
// class ResetPasswordScreen extends StatefulWidget {
//   final String email;
//
//   const ResetPasswordScreen({super.key, required this.email});
//
//   @override
//   State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
// }
//
// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final TextEditingController otpController = TextEditingController();
//   final TextEditingController newPasswordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<ResetPasswordViewModel>(context);
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppStyles.backgroundColor,
//         resizeToAvoidBottomInset: true,
//         body: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               padding: EdgeInsets.only(
//                 left: 24,
//                 right: 24,
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 24,
//               ),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                 child: IntrinsicHeight(
//                   child: Column(
//                     children: [
//                       const AppLogoHeaderOne(showBackButton: false),
//                       const SizedBox(height: 16),
//                       SvgPicture.asset(
//                         'assets/images/confirmed.svg',
//                         height: 280,
//                       ),
//                       const SizedBox(height: 30),
//                       CustomTextField(
//                         labelText: "Mã OTP",
//                         controller: otpController,
//                         isPassword: false,
//                         enabled: true,
//                       ),
//                       const SizedBox(height: 16),
//                       CustomTextField(
//                         labelText: "Mật khẩu mới",
//                         controller: newPasswordController,
//                         isPassword: true,
//                         enabled: true,
//                       ),
//                       const SizedBox(height: 16),
//                       CustomTextField(
//                         labelText: "Nhập lại mật khẩu",
//                         controller: confirmPasswordController,
//                         isPassword: true,
//                         enabled: true,
//                       ),
//                       const SizedBox(height: 24),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 44,
//                         child: ElevatedButton(
//                           onPressed: viewModel.isLoading
//                               ? null
//                               : () {
//                             final otp = otpController.text.trim();
//                             final newPass = newPasswordController.text.trim();
//                             final confirmPass = confirmPasswordController.text.trim();
//
//                             if (otp.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
//                               showErrorSnackBar(context, 'Vui lòng điền đầy đủ thông tin.');
//                               return;
//                             }
//
//                             if (newPass != confirmPass) {
//                               showErrorSnackBar(context, 'Mật khẩu nhập lại không khớp.');
//                               return;
//                             }
//
//                             if (!viewModel.isValidPassword(newPass)) {
//                               showErrorSnackBar(
//                                 context,
//                                 'Mật khẩu phải có ít nhất 8 ký tự, 1 chữ cái viết hoa, 1 số và 1 ký tự đặc biệt.',
//                               );
//                               return;
//                             }
//
//                             viewModel.resetPassword(
//                               widget.email,
//                               otp,
//                               newPass,
//                               context,
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             side: BorderSide(color: Colors.grey.shade300),
//                             elevation: 0,
//                           ),
//                           child: viewModel.isLoading
//                               ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           )
//                               : const Text("Đổi mật khẩu", style: TextStyle(fontSize: 14)),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
// }
