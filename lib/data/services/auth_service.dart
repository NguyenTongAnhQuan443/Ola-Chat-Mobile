import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/api_config.dart';
import 'api_service.dart';
import '../models/auth_response.dart';

class AuthService {
  final ApiService _api = ApiService();

  // Login Phone
  Future<AuthResponse> loginWithPhone(
      String username, String password, String deviceId) async {
    final response = await _api.post(ApiConfig.loginPhone, data: {
      'username': username,
      'password': password,
      'deviceId': deviceId,
    });
    final rawData = response.data['data'];
    if (rawData == null) {
      throw Exception("Không nhận được dữ liệu người dùng từ máy chủ.");
    }
    final auth = AuthResponse.fromJson(rawData);
    await _saveTokens(auth);
    return auth;
  }

  // Login Google
  Future<AuthResponse> loginWithGoogle(String idToken, String deviceId) async {
    final response = await _api.post(
      "${ApiConfig.loginGoogle}?deviceId=$deviceId",
      data: {'idToken': idToken},
    );
    final rawData = response.data['data'];
    if (rawData == null) {
      throw Exception(
          response.data['message'] ?? "Không nhận được dữ liệu từ máy chủ.");
    }
    final auth = AuthResponse.fromJson(rawData);
    await _saveTokens(auth);
    return auth;
  }

  // Login Facebook
  Future<AuthResponse> loginWithFacebook(
      String accessToken, String deviceId) async {
    final response = await _api.post(
      "${ApiConfig.loginFacebook}?deviceId=$deviceId",
      data: {'accessToken': accessToken},
    );
    final rawData = response.data['data'];
    if (rawData == null) {
      throw Exception(
          response.data['message'] ?? "Không nhận được dữ liệu từ máy chủ.");
    }
    final auth = AuthResponse.fromJson(rawData);
    await _saveTokens(auth);
    return auth;
  }

  // OTP
  Future<void> sendOtp(String phone) async {
    await _api.post(ApiConfig.sendOtp, data: {"phone": phone});
  }

  Future<void> verifyOtp(String phone, String otp) async {
    await _api.post(ApiConfig.verifyOtp, data: {"phone": phone, "otp": otp});
  }

  // Register
  Future<void> register(Map<String, dynamic> data) async {
    await _api.post(ApiConfig.register, data: data);
  }

  // Logout
  Future<void> logout(String accessToken, String refreshToken) async {
    await _api.post(ApiConfig.logout, data: {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Save token
  Future<void> _saveTokens(AuthResponse auth) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', auth.token);
    await prefs.setString('refresh_token', auth.refreshToken);
  }
}
