import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/dio_client.dart';

class LoginQrViewModel extends ChangeNotifier {
  Map<String, dynamic>? deviceInfo;
  bool isLoading = false;
  bool isConfirmed = false;

  Future<void> fetchDeviceInfo(String sessionId, String confirmUrl) async {
    isLoading = true;
    notifyListeners();
    print('🚀 Đang gọi API lấy thông tin thiết bị với URL: $confirmUrl');

    try {
      final response = await DioClient().dio.post(confirmUrl);

      deviceInfo = response.data['data'];

// ✅ Tự xây dựng confirmUrl đúng
      final sessionId = response.data['data']['sessionId'];
      final confirmBase = confirmUrl.replaceFirst("/scan", "/confirm");
      deviceInfo!['confirmUrl'] = confirmBase;

      print('🔗 Confirm URL: $confirmBase'); // 👈 in ra để kiểm tra

    } catch (e) {
      print('❌ Lỗi khi fetchDeviceInfo: $e');
      deviceInfo = null;
    }

    isLoading = false;
    notifyListeners();
  }


  Future<bool> confirmLogin(String confirmUrl) async {
    try {
      print('🔐 Gửi request confirmLogin: $confirmUrl');
      final response = await DioClient().dio.post(confirmUrl);
      print('✅ Đăng nhập thành công: ${response.statusCode}');
      isConfirmed = true;
      notifyListeners();
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Lỗi confirmLogin: $e');
      return false;
    }
  }


}
