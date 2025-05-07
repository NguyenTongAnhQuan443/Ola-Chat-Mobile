import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../data/models/auth_response_model.dart';
import '../data/services/token_service.dart';
import '../data/services/auth_service.dart';
import '../core/utils/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import '../firebase_options.dart';

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
        deviceId = '${androidInfo.brand} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await info.iosInfo;
        deviceId = iosInfo.utsname.machine ?? 'iOS';
      }
    } catch (e) {
      deviceId = 'unknown';
    }
    notifyListeners();
  }

  bool _isLoading = false;
  String? _errorMessage;
  AuthResponseModel? _authResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthResponseModel? get authResponse => _authResponse;

  Future<void> _handleLogin(
      Future<AuthResponseModel> Function() loginMethod) async {
    _isLoading = true;
    notifyListeners();
    try {
      _authResponse = await loginMethod();
      _errorMessage = null;
      notifyListeners();

      await TokenService.saveTokens(
        _authResponse!.accessToken,
        _authResponse!.refreshToken,
      );

      final userInfo = await _authService.getMyInfo(_authResponse!.accessToken);
      _userInfo = userInfo;
      // Đăng ký FCM
      final userId = userInfo['userId'];
      await registerDeviceForNotification(userId);

      await TokenService.saveUserInfo(jsonEncode(userInfo));
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
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
    } catch (e) {
      _errorMessage = 'Lỗi Facebook login: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      final access = await TokenService.getAccessToken();
      final refresh = await TokenService.getRefreshToken();
      if (access != null && refresh != null) {
        await _authService.logout(access, refresh);
      }
      await TokenService.clearAll(); // clear cả token và user_info
      _authResponse = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  Future<bool> tryRefreshToken() async {
    final refreshToken = await TokenService.getRefreshToken();
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
        await TokenService.saveTokens(newAccess, newRefresh);
        return true;
      }
    } catch (e) {
      debugPrint('Refresh token lỗi: $e');
    }
    return false;
  }

  Future<bool> validateOrRefreshToken() async {
    final token = await TokenService.getAccessToken();

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
      debugPrint('Introspect token lỗi: $e');
    }

    return await tryRefreshToken();
  }

  Map<String, dynamic>? _userInfo;
  Map<String, dynamic>? get userInfo => _userInfo;

  Future<void> refreshUserInfo() async {
    try {
      final token = await TokenService.getAccessToken();
      if (token == null) throw Exception("Token không tồn tại");

      final userInfo = await _authService.getMyInfo(token);
      _userInfo = userInfo;
      await TokenService.saveUserInfo(jsonEncode(userInfo));
      notifyListeners();
    } catch (e) {
      debugPrint('refreshUserInfo thất bại: $e');
      throw Exception("Lấy thông tin người dùng thất bại");
    }
  }

  Future<String?> getCurrentUserId() async {
    final userJson = await TokenService.getUserInfo();
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      return userMap['userId'];
    }
    return null;
  }

//   NOTIFICATION
  Future<void> registerDeviceForNotification(String userId) async {
    try {
      if (Firebase.apps.isEmpty) {
        debugPrint("⚠️ Firebase chưa được khởi tạo. Đang khởi tạo lại...");
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        debugPrint("⚠️ [FCM] Không lấy được token.");
        return;
      }

      final payload = {
        'userId': userId.toString(),
        'token': fcmToken.toString(),
        'deviceId': deviceId.toString(),
      };

      debugPrint(" [FCM] Gửi yêu cầu đăng ký - Payload: $payload");

      final response = await http.post(
        Uri.parse(ApiConfig.registerDevice),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      final responseBody = utf8.decode(response.bodyBytes);
      debugPrint(
          "✅ [FCM] Phản hồi server (${response.statusCode}): $responseBody");

      if (response.statusCode != 200) {
        throw Exception("Đăng ký FCM thất bại: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ [FCM] Lỗi khi đăng ký: $e");
    }
  }
}
