import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/auth_model.dart';

class AuthService {
  final String _baseUrl = 'http://10.0.2.2:8080/ola-chat/auth';

  Future<AuthResponse> loginWithFacebook(String accessToken) async {
    return await _postRequest(
      endpoint: '/login/facebook',
      body: {'accessToken': accessToken},
      defaultError: 'Đăng nhập Facebook thất bại',
    );
  }

  Future<AuthResponse> loginWithGoogle(String idToken) async {
    return await _postRequest(
      endpoint: '/login/google',
      body: {'idToken': idToken},
      defaultError: 'Đăng nhập Google thất bại',
    );
  }

  Future<AuthResponse> loginWithPhone(String username, String password) async {
    return await _postRequest(
      endpoint: '/login',
      body: {
        'username': username,
        'password': password,
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

      if (response.statusCode == 200 && data['data'] != null) {
        return AuthResponse.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? defaultError);
      }
    } catch (e) {
      rethrow;
    }
  }
}
