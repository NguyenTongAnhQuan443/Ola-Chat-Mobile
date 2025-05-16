import 'dart:convert';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../models/auth_response_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final ApiService _api = ApiService();

  // Login Phone
  Future<AuthResponseModel> loginWithPhone(
      String username, String password, String deviceId) async {
    final response = await _api.post(ApiConfig.authLoginPhone, data: {
      'username': username,
      'password': password,
      'deviceId': deviceId,
    });
    final rawData = response.data['data'];
    if (rawData == null) {
      throw Exception("Không nhận được dữ liệu người dùng từ máy chủ.");
    }
    final auth = AuthResponseModel.fromJson(rawData);
    await _saveTokens(auth);
    return auth;
  }

  // Login Google
  Future<AuthResponseModel> loginWithGoogle(String idToken, String deviceId) async {
    final response = await _api.post(
      "${ApiConfig.authLoginGoogle}?deviceId=$deviceId",
      data: {'idToken': idToken},
    );
    final rawData = response.data['data'];
    if (rawData == null) {
      throw Exception(
          response.data['message'] ?? "Không nhận được dữ liệu từ máy chủ.");
    }
    final auth = AuthResponseModel.fromJson(rawData);
    await _saveTokens(auth);
    return auth;
  }

  // Login Facebook
  Future<AuthResponseModel> loginWithFacebook(
      String accessToken, String deviceId) async {
    final response = await _api.post(
      "${ApiConfig.authLoginFacebook}?deviceId=$deviceId",
      data: {'accessToken': accessToken},
    );
    final rawData = response.data['data'];
    if (rawData == null) {
      throw Exception(
          response.data['message'] ?? "Không nhận được dữ liệu từ máy chủ.");
    }
    final auth = AuthResponseModel.fromJson(rawData);
    await _saveTokens(auth);
    return auth;
  }

  // Gửi OTP với provider
  Future<void> sendOtp(String phone, {String provider = "vonage"}) async {
    await _api.post(ApiConfig.otpSend, data: {
      "phone": phone,
      "provider": provider,
    });
  }

  // Xác minh OTP với provider
  Future<void> verifyOtp(String phone, String otp,
      {String provider = "vonage"}) async {
    await _api.post(ApiConfig.otpVerify, data: {
      "phone": phone,
      "otp": otp,
      "provider": provider,
    });
  }

  // Register
  Future<void> register(Map<String, dynamic> data) async {
    await _api.post(ApiConfig.authRegister, data: data);
  }

  // Logout
  Future<void> logout(String accessToken, String refreshToken) async {
    await _api.post(ApiConfig.authLogout, data: {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Save token
  Future<void> _saveTokens(AuthResponseModel auth) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', auth.accessToken);
    await prefs.setString('refresh_token', auth.refreshToken);
  }

  // Get Info User
  Future<Map<String, dynamic>> getMyInfo(String accessToken) async {
    final response = await _api.get(ApiConfig.userInfo);

    final data = response.data;
    if (response.statusCode == 200 && data['success'] == true) {
      return data['data'];
    } else {
      throw Exception('${AppStyles.failureIcon}Lấy thông tin người dùng thất bại');
    }
  }
}