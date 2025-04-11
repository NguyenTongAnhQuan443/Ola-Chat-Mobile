import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/auth_response.dart';
import '../data/services/auth_service.dart';
import '../core/config/api_config.dart';
import 'package:http/http.dart' as http;

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;
  String deviceId = 'unknown';

  LoginViewModel({AuthService? authService})
      : _authService = authService ?? AuthService() {
    _initDeviceId();
  }

  Future<void> _initDeviceId() async {
    try {
      final info = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await info.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await info.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'unknown';
      }
    } catch (e) {
      print('⚠️ Device ID error: $e');
    }
    notifyListeners();
  }

  bool _isLoading = false;
  String? _errorMessage;
  AuthResponse? _authResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthResponse? get authResponse => _authResponse;

  Future<void> _handleLogin(Future<AuthResponse> Function() loginMethod) async {
    _isLoading = true;
    notifyListeners();

    try {
      _authResponse = await loginMethod();
      _errorMessage = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', _authResponse!.token);
      await prefs.setString('refresh_token', _authResponse!.refreshToken);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithPhone(String username, String password) async {
    await _handleLogin(
        () => _authService.loginWithPhone(username, password, deviceId));
  }

  Future<void> loginWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      scopes: ['email'],
      serverClientId:
          '714231235616-gorl6sl5fja3tgja1pfl9la9qd3b9orf.apps.googleusercontent.com',
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      _errorMessage = 'Hủy đăng nhập Google';
      notifyListeners();
      return;
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      _errorMessage = 'Không lấy được ID Token';
      notifyListeners();
      return;
    }

    await _handleLogin(() => _authService.loginWithGoogle(idToken, deviceId));
  }

  Future<void> loginWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken?.tokenString;
        if (accessToken == null) {
          _errorMessage = 'Không lấy được access token từ Facebook.';
          notifyListeners();
          return;
        }

        print('🔵 [FACEBOOK ACCESS TOKEN]: $accessToken');

        await _handleLogin(
            () => _authService.loginWithFacebook(accessToken, deviceId));
      } else {
        _errorMessage = 'Facebook login bị hủy hoặc lỗi.';
        notifyListeners();
      }
    } catch (e, stack) {
      print('❌ Facebook login lỗi: $e\n$stack');
      _errorMessage = 'Lỗi Facebook login: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final access = prefs.getString('access_token');
      final refresh = prefs.getString('refresh_token');

      if (access != null && refresh != null) {
        await _authService.logout(access, refresh);
      }

      await prefs.clear();
      _authResponse = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> tryRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');
    if (refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.base}/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && data['success'] == true) {
        final newAccess = data['data']['accessToken'];
        final newRefresh = data['data']['refreshToken'];
        await prefs.setString('access_token', newAccess);
        await prefs.setString('refresh_token', newRefresh);
        return true;
      }
    } catch (e) {
      print('❌ Refresh token lỗi: $e');
    }

    return false;
  }

  Future<bool> validateOrRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) return false;

    try {
      final res = await http.post(
        Uri.parse(ApiConfig.authIntrospect),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      final body = jsonDecode(res.body);
      final isValid = body['success'] == true;

      if (isValid) return true;
    } catch (e) {
      print('❌ Introspect token lỗi: $e');
    }

    return await tryRefreshToken();
  }
}
