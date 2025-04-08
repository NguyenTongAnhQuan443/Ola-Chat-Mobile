import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/auth_model.dart';

class AuthService {
  final String _baseUrl = 'http://10.0.2.2:8080/ola-chat/auth';

  Future<AuthResponse> loginWithGoogle(String idToken, String deviceId) async {
    return await _postRequest(
      endpoint: '/login/google?deviceId=$deviceId',
      body: {'idToken': idToken},
      defaultError: 'Đăng nhập Google thất bại',
    );
  }

  Future<AuthResponse> loginWithFacebook(String accessToken, String deviceId) async {
    return await _postRequest(
      endpoint: '/login/facebook?deviceId=$deviceId',
      body: {'accessToken': accessToken},
      defaultError: 'Đăng nhập Facebook thất bại',
    );
  }


  Future<AuthResponse> loginWithPhone(String username, String password, String deviceId) async {
    return await _postRequest(
      endpoint: '/login',
      body: {
        'username': username,
        'password': password,
        'deviceId': deviceId,
      },
      defaultError: 'Đăng nhập thất bại',
    );
  }

  Future<AuthResponse> _postRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    required String defaultError,
  }) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      print('🔥 TOKEN FORMAT CHECK: ${data['data']['token']}');

      if (response.statusCode == 200 && data['data'] != null) {
        final auth = AuthResponse.fromJson(data['data']);
        return auth;
      } else {
        throw Exception(data['message'] ?? defaultError);
      }

    } catch (e) {
      rethrow;
    }
  }
}
