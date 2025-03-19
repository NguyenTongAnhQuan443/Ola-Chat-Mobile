import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../data/models/login_response.dart';

class AuthViewModel extends ChangeNotifier {
  Future<String?> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }
    return null;
  }

  Future<LoginResponse?> loginWithPhoneNumber(String phone, String password) async {
    final deviceId = await _getDeviceId();
    if (deviceId == null) return null;

    final Uri url = Uri.parse("https://silenthero.xyz/api/auth/login-phone");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode({
          "phoneNumber": phone,
          "password": password,
          "deviceId": deviceId,
        }),
      );

      final decodedBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedBody);

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(data);

        // Lưu token vào SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("accessToken", loginResponse.accessToken);

        return loginResponse;
      } else {
        // Lấy message lỗi từ API
        throw Exception(data["message"] ?? "Đăng nhập thất bại!");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }
}
