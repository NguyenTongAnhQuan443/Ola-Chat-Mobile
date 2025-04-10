import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/auth_response.dart';
import '../data/services/auth_service.dart';

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
      print('⚠️ Lỗi khi lấy deviceId: $e');
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

      // 🔐 Lưu token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', _authResponse!.token);
      await prefs.setString('refresh_token', _authResponse!.refreshToken);
      print('   🔐 access: ${_authResponse!.token}');
      print('   ♻️ refresh: ${_authResponse!.refreshToken}');

    } catch (e, stack) {
      print('❌ Lỗi đăng nhập: $e');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithFacebook() async {
    final result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final accessToken = result.accessToken!.tokenString;
      print('🔵 [FACEBOOK ACCESS TOKEN]: $accessToken');

      await _handleLogin(() => _authService.loginWithFacebook(accessToken, deviceId));
    } else {
      _errorMessage = 'Đăng nhập Facebook thất bại';
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
      serverClientId: '714231235616-gorl6sl5fja3tgja1pfl9la9qd3b9orf.apps.googleusercontent.com',
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

    print('🟢 [GOOGLE ID TOKEN]: $idToken');

    await _handleLogin(() => _authService.loginWithGoogle(idToken, deviceId));
  }

  Future<void> loginWithPhone(String username, String password) async {
    await _handleLogin(() => _authService.loginWithPhone(username, password, deviceId));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');

    print('🧾 accessToken: $accessToken');
    print('🧾 refreshToken: $refreshToken');

    if (accessToken == null || refreshToken == null) {
      _errorMessage = 'Không tìm thấy accessToken hoặc refreshToken';
      notifyListeners();
      return;
    }

    try {
      await _authService.logout(accessToken, refreshToken);
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');

      print('✅ Logout thành công');
    } catch (e) {
      _errorMessage = 'Lỗi khi gọi API logout: $e';
      notifyListeners();
      rethrow;
    }
  }

}
