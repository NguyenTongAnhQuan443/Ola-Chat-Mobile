import 'package:dio/dio.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'dio_client.dart';

class ApiService {
  final Dio _dio = DioClient().dio;

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(path, data: data);
      print("[API POST SUCCESS] - $path → ${response.data}");
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        print("[API POST ERROR] - $path → ${e.response?.data}");
        throw Exception(e.response?.data['message'] ?? 'Lỗi máy chủ.');
      } else {
        print(
            "${AppStyles.warningIcon}[API ERROR - NO RESPONSE] - $path → ${e.message}");
        throw Exception("Không thể kết nối máy chủ: ${e.message}");
      }
    }
  }

  Future<Response> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response;
    } catch (e) {
      throw Exception("${AppStyles.failureIcon}GET lỗi: $e");
    }
  }
}
