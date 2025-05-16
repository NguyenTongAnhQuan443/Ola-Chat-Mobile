import 'package:dio/dio.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'dio_client.dart';

class ApiService {
  final Dio _dio = DioClient().dio;

  /// [useFormUrlEncoded]: nếu true, sẽ gửi dữ liệu theo dạng form-urlencoded
  Future<Response> post(String path,
      {Map<String, dynamic>? data, bool useFormUrlEncoded = false}) async {
    try {
      final response = await _dio.post(
        path,
        data: useFormUrlEncoded ? FormData.fromMap(data ?? {}) : data,
        options: useFormUrlEncoded
            ? Options(contentType: Headers.formUrlEncodedContentType)
            : null,
      );

      print(
          "${AppStyles.successIcon}[API POST SUCCESS] - $path → ${response.data}");
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        print(
            "${AppStyles.failureIcon}[API POST ERROR] - $path → ${e.response?.data}");
        throw Exception(e.response?.data['message'] ?? 'Lỗi máy chủ.');
      } else {
        print(
            "${AppStyles.warningIcon}[API ERROR - NO RESPONSE] - $path → ${e.message}");
        print("${AppStyles.failureIcon}[DIO EXCEPTION] type: ${e.type}");
        print("${AppStyles.failureIcon}[DIO EXCEPTION] message: ${e.message}");
        print(
            "${AppStyles.failureIcon}[DIO EXCEPTION] request: ${e.requestOptions.uri}");
        print("${AppStyles.failureIcon}[DIO EXCEPTION] error: ${e.error}");
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
