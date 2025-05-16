import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/models/auth_response_model.dart';
import 'package:olachat_mobile/services/api_service.dart';
import 'package:olachat_mobile/services/token_service.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

class AuthService {
  final ApiService _api = ApiService();

  // Gộp chung xử lý login response
  Future<AuthResponseModel> _processLoginResponse(Response response) async {
    final rawData = response.data['data'];
    if (rawData == null) {
      throw Exception(response.data['message'] ?? 'Không nhận được dữ liệu từ máy chủ.');
    }
    final auth = AuthResponseModel.fromJson(rawData);
    await TokenService.saveTokens(auth.accessToken, auth.refreshToken);
    return auth;
  }

  // Đăng nhập bằng số điện thoại
  Future<AuthResponseModel> loginWithPhone(
      String username, String password, String deviceId) async {
    final response = await _api.post(ApiConfig.authLoginPhone, data: {
      'username': username,
      'password': password,
      'deviceId': deviceId,
    });
    return await _processLoginResponse(response);
  }

  // Đăng nhập bằng Google
  Future<AuthResponseModel> loginWithGoogle(String idToken, String deviceId) async {
    final response = await _api.post(
      "${ApiConfig.authLoginGoogle}?deviceId=$deviceId",
      data: {'idToken': idToken},
      useFormUrlEncoded: true,
    );
    return await _processLoginResponse(response);
  }

  // Đăng nhập bằng Facebook
  Future<AuthResponseModel> loginWithFacebook(
      String accessToken, String deviceId) async {
    final response = await _api.post(
      "${ApiConfig.authLoginFacebook}?deviceId=$deviceId",
      data: {'accessToken': accessToken},
      useFormUrlEncoded: true,
    );
    return await _processLoginResponse(response);
  }

  // Gửi OTP
  Future<void> sendOtp(String phone, {String provider = "vonage"}) async {
    await _api.post(ApiConfig.otpSend, data: {
      "phone": phone,
      "provider": provider,
    });
  }

  // Xác minh OTP
  Future<void> verifyOtp(String phone, String otp, {String provider = "vonage"}) async {
    await _api.post(ApiConfig.otpVerify, data: {
      "phone": phone,
      "otp": otp,
      "provider": provider,
    });
  }

  // Đăng ký tài khoản
  Future<void> register(Map<String, dynamic> data) async {
    await _api.post(ApiConfig.authRegister, data: data);
  }

  // Đăng xuất
  Future<void> logout(String accessToken, String refreshToken) async {
    await _api.post(ApiConfig.authLogout, data: {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    });
    await TokenService.clearAll(); // dùng service thay vì SharedPreferences trực tiếp
  }

  // Lấy thông tin người dùng
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
