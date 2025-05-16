import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/services/token_service.dart';
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
        final List<String> publicEndpoints = [
          '/auth/login',
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

        // Kiểm tra xem URL có thuộc danh sách public hay không
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
        final isUnauthorized = error.response?.statusCode == 401;

        // Trường hợp đặc biệt: không có response mà vẫn phải kiểm tra lại token
        final isUnknownWithAccessToken =
            error.type == DioExceptionType.unknown &&
                await TokenService.getAccessToken() != null;

        if (isUnauthorized || isUnknownWithAccessToken) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            final newToken = await TokenService.getAccessToken();
            final options = Options(
              method: error.requestOptions.method,
              headers: {
                ...error.requestOptions.headers,
                'Authorization': 'Bearer $newToken',
              },
            );

            try {
              final response = await dio.request(
                error.requestOptions.path,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
                options: options,
              );
              return handler.resolve(response);
            } catch (_) {
              // Nếu gọi lại cũng lỗi → tiếp tục trả lỗi
              return handler.next(error);
            }
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
        await TokenService.saveTokens(
            data['accessToken'], data['refreshToken']);
        print("${AppStyles.greenPointIcon}Token đã được làm mới thành công");
        return true;
      }
    } catch (e) {
      print('${AppStyles.failureIcon}[DIO] Refresh token failed: $e');
    }
    return false;
  }
}
