import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient()
      : dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8080/ola-chat',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
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
      throw Exception('❌ Lỗi API: $msg');
    } catch (e) {
      throw Exception('❌ Lỗi không xác định: $e');
    }
  }
}
