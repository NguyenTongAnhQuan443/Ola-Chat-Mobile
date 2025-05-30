import 'dart:io';
import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'dio_client.dart';

class PostService {
  final Dio _dio = DioClient().dio;

  Future<bool> createPost({
    required String content,
    required String privacy,
    required List<File> files,
  }) async {
    try {
      final formData = FormData.fromMap({
        'content': content,
        'privacy': privacy,
        'files': await Future.wait(files.map((file) async {
          return await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          );
        })),
      });

      final response = await _dio.post(ApiConfig.createPost, data: formData);
      print("🟢 Tạo bài viết thành công: ${response.data}");
      return response.statusCode == 200;
    } catch (e) {
      print("❌ Lỗi tạo bài viết: $e");
      return false;
    }
  }
}
