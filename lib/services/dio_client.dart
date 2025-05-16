import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/main.dart';
import 'package:olachat_mobile/services/token_service.dart';
import 'package:olachat_mobile/services/socket_service.dart';
import 'package:olachat_mobile/ui/views/login_screen.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConfig.base,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        const publicEndpoints = [
          '/auth/login',
          '/auth/login/google',
          '/auth/login/facebook',
          '/auth/introspect',
          '/auth/logout',
          '/auth/refresh',
          '/auth/forgot-password',
          '/auth/reset-password',
          '/v3/api-docs',
          '/swagger-ui',
          '/otp',
          '/twilio',
          '/ws',
          '/api/messages',
          '/api/login-history',
          '/files',
          '/api/friends',
          '/users',
          '/api/notifications/register-device',
        ];

        final isPublic = publicEndpoints.any((path) =>
        options.path.startsWith(path) || options.uri.path.contains(path));

        if (!isPublic) {
          final token = await TokenService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }

        handler.next(options);
      },

      onError: (error, handler) async {
        final requestOptions = error.requestOptions;
        final hasRetried = requestOptions.extra['hasRetried'] == true;

        final isUnauthorized = error.response?.statusCode == 401;
        final isUnknownWithToken =
            error.type == DioExceptionType.unknown &&
                await TokenService.getAccessToken() != null;

        if ((isUnauthorized || isUnknownWithToken) && !hasRetried) {
          final refreshed = await _refreshToken();

          if (refreshed) {
            final newToken = await TokenService.getAccessToken();

            final newOptions = Options(
              method: requestOptions.method,
              headers: {
                ...requestOptions.headers,
                'Authorization': 'Bearer $newToken',
              },
              extra: {
                ...requestOptions.extra,
                'hasRetried': true,
              },
            );

            try {
              final response = await dio.request(
                requestOptions.path,
                data: requestOptions.data,
                queryParameters: requestOptions.queryParameters,
                options: newOptions,
              );
              return handler.resolve(response);
            } catch (_) {
              return handler.next(error);
            }
          } else {
            await _forceLogout(); // GỌI NGẮT SOCKET + ĐĂNG XUẤT
            return handler.reject(error);
          }
        }

        return handler.next(error);
      },
    ));
  }

  static Future<bool> _refreshToken() async {
    final refreshToken = await TokenService.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final dio = Dio();
      final response = await dio.post(
        ApiConfig.authRefresh,
        data: {'refreshToken': refreshToken},
      );

      final data = response.data['data'];
      if (response.statusCode == 200 && data != null) {
        await TokenService.saveTokens(data['accessToken'], data['refreshToken']);
        print("${AppStyles.greenPointIcon} Token đã được làm mới thành công.");
        return true;
      }
    } catch (e) {
      print("${AppStyles.failureIcon} Refresh token thất bại: $e");
    }

    return false;
  }

  static Future<void> _forceLogout() async {
    print('${AppStyles.failureIcon} Token không còn hợp lệ. Đăng xuất người dùng...');

    // Ngắt kết nối socket
    SocketService().disconnect();

    // Xoá token và dữ liệu liên quan
    await TokenService.clearAll();

    // Chuyển về màn hình đăng nhập
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }
}
