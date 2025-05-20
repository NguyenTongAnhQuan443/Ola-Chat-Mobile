import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/models/auth_response_model.dart';
import 'package:olachat_mobile/services/auth_service.dart';
import 'package:olachat_mobile/services/dio_client.dart';
import 'package:olachat_mobile/services/token_service.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

import '../utils/firebase_options.dart';

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
    print("${AppStyles.successIcon}[DEBUG] GOOGLE ID TOKEN = $idToken");
    print(
        "${AppStyles.successIcon}🟡 [DEBUG] ID TOKEN LENGTH = ${idToken?.length}");
    print(
        "${AppStyles.successIcon} [DEBUG] ID TOKEN FORMAT = ${idToken?.split('.').length ?? 0} parts");

    if (idToken == null) {
      _errorMessage = 'Không lấy được ID Token';
      notifyListeners();
      return;
    }

    await _handleLogin(() =>
        _authService.loginWithGoogle(idToken, Uri.encodeComponent(deviceId)));
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
        print('${AppStyles.successIcon}[FACEBOOK ACCESS TOKEN]: $accessToken');
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

  Map<String, dynamic>? _userInfo;
  Map<String, dynamic>? get userInfo => _userInfo;

  Future<void> refreshUserInfo() async {
    try {
      final token = await TokenService.getAccessToken();
      if (token == null)
        throw Exception("${AppStyles.failureIcon}Token không tồn tại");

      final userInfo = await _authService.getMyInfo(token);
      _userInfo = userInfo;
      await TokenService.saveUserInfo(jsonEncode(userInfo));
      notifyListeners();
    } catch (e) {
      debugPrint('${AppStyles.failureIcon}refreshUserInfo thất bại: $e');
      throw Exception(
          "${AppStyles.failureIcon}Lấy thông tin người dùng thất bại");
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
        debugPrint("${AppStyles.warningIcon} Firebase chưa khởi tạo. Khởi tạo lại...");
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      }
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        debugPrint('${AppStyles.failureIcon} [FCM] Không lấy được token.');
        return;
      }

      final payload = {
        'userId': userId,
        'token': fcmToken,
        'deviceId': deviceId,
      };
      debugPrint('${AppStyles.greenPointIcon} [FCM] Payload gửi đăng ký: $payload');
      final response = await DioClient().dio.post(
        ApiConfig.registerDevice,
        data: payload,
      );
      debugPrint('${AppStyles.greenPointIcon} [FCM] Phản hồi server (${response.statusCode}): ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        debugPrint('${AppStyles.successIcon} [FCM] Đăng ký thiết bị FCM thành công.');
      } else {
        debugPrint('${AppStyles.failureIcon} [FCM] Đăng ký thiết bị FCM thất bại: ${response.data}');
      }
    } catch (e) {
      debugPrint('${AppStyles.failureIcon} [FCM] Lỗi khi đăng ký: $e');
    }
  }



  Future<bool> validateAndFetchUserInfo() async {
    final accessToken = await TokenService.getAccessToken();
    final refreshToken = await TokenService.getRefreshToken();

    if (accessToken == null || refreshToken == null) return false;

    try {
      final res = await DioClient()
          .dio
          .post(ApiConfig.authIntrospect, data: {'token': accessToken});
      final body = res.data;
      if (body['success'] == true) {
        await refreshUserInfo();
        return true;
      }
    } catch (_) {}
    return false;
  }
}
