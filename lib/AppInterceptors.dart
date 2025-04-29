import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/models/TokenResponse.dart';
import 'data/services/TokenService.dart';

class AppInterceptors extends Interceptor {
  final Dio dio;

  AppInterceptors(this.dio);

  @override
  @override
  Future<void> onError(DioError error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401) {
      final oldAccessToken = await TokenService.getAccessToken();
      final refreshToken = await TokenService.getRefreshToken();

      if (oldAccessToken != null && refreshToken != null) {
        final newTokens = await refreshAccessToken(oldAccessToken, refreshToken);

        if (newTokens != null) {
          // LƯU TOKEN MỚI tại đây
          await TokenService.saveTokens(newTokens.accessToken, newTokens.refreshToken);

          // Retry lại request cũ
          final opts = error.requestOptions;
          opts.headers["Authorization"] = "Bearer ${newTokens.accessToken}";

          final cloneReq = await dio.request(
            opts.path,
            options: Options(
              method: opts.method,
              headers: opts.headers,
            ),
            data: opts.data,
            queryParameters: opts.queryParameters,
          );

          return handler.resolve(cloneReq);
        } else {
          // Nếu refresh thất bại thì xóa token + logout
          await TokenService.clearAll();
        }
      }
    }
    return handler.next(error);
  }
}
