// import 'package:flutter/material.dart';
// import 'package:olachat_mobile/ui/widgets/custom_textfield_settings.dart';
// import 'package:olachat_mobile/view_models/user_setting_introduce_view_model.dart';
// import 'package:provider/provider.dart';
//
// class UserSettingIntroduceScreen extends StatelessWidget {
//   // User_Setting_Introduce
//   const UserSettingIntroduceScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => UserSettingIntroduceViewModel(),
//       child: Consumer<UserSettingIntroduceViewModel>(
//         builder: (context, vm, _) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 35),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 24),
//                 CustomTextFieldSettings(
//                   label: "Họ và tên",
//                   controller: vm.fullNameController,
//                 ),
//                 const SizedBox(height: 16),
//                 CustomTextFieldSettings(
//                   label: "Biệt danh",
//                   controller: vm.nicknameController,
//                 ),
//                 const SizedBox(height: 16),
//                 CustomTextFieldSettings(
//                   label: "Bio",
//                   maxLines: 3,
//                   controller: vm.bioController,
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 44,
//                   child: ElevatedButton(
//                     onPressed: vm.isLoading
//                         ? null
//                         : () => vm.updateProfile(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: vm.isLoading
//                         ? const CircularProgressIndicator(
//                         color: Colors.white, strokeWidth: 2)
//                         : const Text(
//                       "Cập nhật",
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
