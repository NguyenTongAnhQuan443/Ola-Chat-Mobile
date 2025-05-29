import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

class ApiClient {
  final Dio dio;

  ApiClient()
      : dio = Dio(BaseOptions(
          baseUrl: ApiConfig.base,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 50),
          headers: {
            'Content-Type': 'application/json',
          },
        ));

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception('${AppStyles.failureIcon}Lỗi API: $msg');
    } catch (e) {
      throw Exception('${AppStyles.failureIcon}Lỗi không xác định: $e');
    }
  }
}
