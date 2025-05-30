import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import '../services/dio_client.dart';

class LoginQrViewModel extends ChangeNotifier {
  Map<String, dynamic>? deviceInfo;
  bool isLoading = false;
  bool isConfirmed = false;

  Future<void> fetchDeviceInfo(String sessionId, String confirmUrl) async {
    isLoading = true;
    notifyListeners();
    print('${AppStyles.wattingIcon} Đang gọi API lấy thông tin thiết bị với URL: $confirmUrl');

    try {
      final response = await DioClient().dio.post(confirmUrl);
      deviceInfo = response.data['data'];
      final sessionId = response.data['data']['sessionId'];
      final confirmBase = confirmUrl.replaceFirst("/scan", "/confirm");
      deviceInfo!['confirmUrl'] = confirmBase;

      print('${AppStyles.connectIcon} Confirm URL: $confirmBase');
    } catch (e) {
      print('${AppStyles.failureIcon}Lỗi khi fetchDeviceInfo: $e');
      deviceInfo = null;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> confirmLogin(String confirmUrl) async {
    try {
      print('${AppStyles.wattingIcon}Gửi request confirmLogin: $confirmUrl');
      final response = await DioClient().dio.post(confirmUrl);
      print('${AppStyles.successIcon}Đăng nhập thành công: ${response.statusCode}');
      isConfirmed = true;
      notifyListeners();
      return response.statusCode == 200;
    } catch (e) {
      print('${AppStyles.failureIcon}Lỗi confirmLogin: $e');
      return false;
    }
  }
}
