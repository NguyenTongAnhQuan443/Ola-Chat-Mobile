// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:http/http.dart' as http;
// import 'package:olachat_mobile/config/api_config.dart';
// import 'package:olachat_mobile/ui/views/signup_screen.dart';
// import 'package:olachat_mobile/ui/widgets/app_logo_header_one.dart';
// import 'package:olachat_mobile/ui/widgets/custom_textfield.dart';
// import 'package:olachat_mobile/utils/app_styles.dart';
// import '../../main.dart';
// import '../widgets/show_snack_bar.dart';
//
// class PhoneVerificationScreen extends StatefulWidget {
//   const PhoneVerificationScreen({super.key});
//
//   @override
//   State<PhoneVerificationScreen> createState() =>
//       _PhoneVerificationScreenState();
// }
//
// class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//   bool isOtpSent = false;
//
//   Future<void> sendOtp() async {
//     final phone = phoneController.text.trim();
//     if (!isValidPhone(phone)) {
//       showErrorSnackBar(
//           navigatorKey.currentContext!,
//           "Số điện thoại không hợp lệ. Phải bắt đầu bằng số 0 và đủ 10 chữ số.");
//       return;
//     }
//
//     try {
//       final res = await http.post(
//         Uri.parse(ApiConfig.otpSend),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"phone": phone, "provider": "vonage"}),
//       );
//
//       if (res.statusCode == 200) {
//         setState(() => isOtpSent = true);
//         showSuccessSnackBar(
//             navigatorKey.currentContext!, "Mã OTP đã gửi về số điện thoại");
//       } else {
//         showErrorSnackBar(navigatorKey.currentContext!,
//             "Không thể gửi OTP. Mã lỗi: ${res.statusCode}");
//       }
//     } catch (e) {
//       showErrorSnackBar(
//           navigatorKey.currentContext!, "Lỗi gửi OTP: ${e.toString()}");
//     }
//   }
//
//   Future<void> verifyOtp() async {
//     final phone = phoneController.text.trim();
//     final otp = otpController.text.trim();
//
//     if (!isValidPhone(phone) || otp.isEmpty) {
//       showErrorSnackBar(context, "Vui lòng nhập đúng số điện thoại và mã OTP.");
//       return;
//     }
//
//     try {
//       final res = await http.post(
//         Uri.parse(ApiConfig.otpVerify),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "phone": phone,
//           "otp": otp,
//           "provider": "vonage",
//         }),
//       );
//
//       final responseData = jsonDecode(utf8.decode(res.bodyBytes));
//
//       if (res.statusCode == 200 && responseData['success'] == true) {
//         navigatorKey.currentState!.pushReplacement(
//           MaterialPageRoute(
//             builder: (_) => SignUpScreen(phoneNumber: phone),
//           ),
//         );
//       } else {
//         showErrorSnackBar(
//           navigatorKey.currentContext!,
//           responseData['message'] ?? "OTP không hợp lệ hoặc đã hết hạn.",
//         );
//       }
//     } catch (e) {
//       showErrorSnackBar(
//           navigatorKey.currentContext!, "Lỗi xác thực OTP: ${e.toString()}");
//     }
//   }
//
//   bool isValidPhone(String phone) {
//     final trimmed = phone.trim();
//     final regex = RegExp(r'^0\d{9}$');
//     return regex.hasMatch(trimmed);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: Scaffold(
//           resizeToAvoidBottomInset: true,
//           backgroundColor: AppStyles.backgroundColor,
//           body: LayoutBuilder(
//             builder: (context, constraints) {
//               return SingleChildScrollView(
//                 reverse: true,
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                   child: IntrinsicHeight(
//                     child: Column(
//                       children: [
//                         AppLogoHeaderOne(showBackButton: true),
//                         Expanded(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SvgPicture.asset(
//                                 'assets/images/verify_phone.svg',
//                                 height: 300,
//                               ),
//                               const SizedBox(height: 30),
//                               CustomTextField(
//                                 labelText: "Số điện thoại",
//                                 controller: phoneController,
//                                 isPassword: false,
//                                 enabled: !isOtpSent,
//                               ),
//                               const SizedBox(height: 16),
//                               if (isOtpSent)
//                                 Column(
//                                   children: [
//                                     CustomTextField(
//                                       labelText: "Mã OTP",
//                                       controller: otpController,
//                                       isPassword: false,
//                                       enabled: isOtpSent,
//                                     ),
//                                     const SizedBox(height: 16),
//                                   ],
//                                 ),
//                               SizedBox(
//                                 width: double.infinity,
//                                 height: 44,
//                                 child: ElevatedButton(
//                                   onPressed: () =>
//                                   isOtpSent ? verifyOtp() : sendOtp(),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.black,
//                                     foregroundColor: Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     side: BorderSide(color: Colors.grey.shade300),
//                                     elevation: 0,
//                                   ),
//                                   child: Text(
//                                     isOtpSent ? "Xác minh OTP" : "Gửi mã OTP",
//                                     style: const TextStyle(fontSize: 14),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 30),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Text("Đã có tài khoản?",
//                                       style: TextStyle(fontSize: 14)),
//                                   const SizedBox(width: 5),
//                                   InkWell(
//                                     onTap: () => Navigator.pop(context),
//                                     child: const Text(
//                                       "Đăng nhập",
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
