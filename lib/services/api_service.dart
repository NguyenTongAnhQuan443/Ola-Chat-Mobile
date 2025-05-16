import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.host,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(path, data: data);
      print("${AppStyles.successIcon}[API POST SUCCESS] - $path → ${response.data}");
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        print("${AppStyles.failureIcon}[API POST ERROR] - $path → ${e.response?.data}");
        throw Exception(e.response?.data['message'] ?? 'Lỗi máy chủ.');
      } else {
        print("${AppStyles.warningIcon}[API ERROR - NO RESPONSE] - $path → ${e.message}");
        throw Exception("Không thể kết nối máy chủ: ${e.message}");
      }
    }
  }
}
