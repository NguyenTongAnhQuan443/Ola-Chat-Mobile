import '../core/utils/ApiClient.dart';
import '../data/models/auth_response.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<AuthResponse> loginWithPhone(String username, String password, String deviceId) async {
    final response = await _apiClient.post('/auth/login', data: {
      'username': username,
      'password': password,
      'deviceId': deviceId,
    });

    final data = response.data['data'];
    return AuthResponse.fromJson(data);
  }

  Future<AuthResponse> loginWithGoogle(String idToken, String deviceId) async {
    final response = await _apiClient.post('/auth/login/google?deviceId=$deviceId', data: {
      'idToken': idToken,
    });

    final data = response.data['data'];
    return AuthResponse.fromJson(data);
  }

  Future<AuthResponse> loginWithFacebook(String accessToken, String deviceId) async {
    final response = await _apiClient.post('/auth/login/facebook?deviceId=$deviceId', data: {
      'accessToken': accessToken,
    });

    final data = response.data['data'];
    return AuthResponse.fromJson(data);
  }

  Future<void> logout(String accessToken, String refreshToken) async {
    await _apiClient.post('/auth/logout', data: {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    });
  }
}
