// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:olachat_mobile/config/api_config.dart';
// import 'package:olachat_mobile/view_models/login_view_model.dart';
// import 'package:olachat_mobile/ui/widgets/show_snack_bar.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class UserSettingAvatarViewModel extends ChangeNotifier {
//   File? selectedImage;
//   bool isLoading = false;
//
//   void selectImage(File image) {
//     selectedImage = image;
//     notifyListeners();
//   }
//
//   Future<void> updateAvatar(BuildContext context) async {
//     if (selectedImage == null) {
//       showErrorSnackBar(context, "Vui lòng chọn ảnh trước khi cập nhật.");
//       return;
//     }
//
//     try {
//       isLoading = true;
//       notifyListeners();
//
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('access_token');
//
//       final request = http.MultipartRequest(
//         'PUT',
//         Uri.parse(ApiConfig.updateAvatar),
//       );
//       request.headers['Authorization'] = 'Bearer $token';
//       request.files.add(await http.MultipartFile.fromPath('avatar', selectedImage!.path));
//
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);
//
//       if (response.statusCode == 200) {
//         // Làm mới dữ liệu user từ LoginViewModel
//         await Provider.of<LoginViewModel>(context, listen: false).refreshUserInfo();
//
//         // Reset hình đã chọn
//         selectedImage = null;
//         showSuccessSnackBar(context, "Cập nhật ảnh đại diện thành công");
//       } else {
//         showErrorSnackBar(context, "Cập nhật thất bại");
//       }
//     } catch (e) {
//       showErrorSnackBar(context, "Có lỗi xảy ra: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }
