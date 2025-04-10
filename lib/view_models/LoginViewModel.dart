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
    final GoogleSignIn googleSignIn = GoogleSignIn(
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
      } else {
        _errorMessage = 'Không tìm thấy token.';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
