import 'dart:io';
import 'package:dio/dio.dart';
import 'package:olachat_mobile/services/token_service.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import '../config/api_config.dart';
import 'dio_client.dart';

class FileUploadService {
  final Dio _dio = DioClient().dio;

  Future<List<String>> uploadFiles(List<File> files) async {
    try {
      final accessToken = await TokenService.getAccessToken(); // 👈 Lấy token

      final formData = FormData();

      for (final file in files) {
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ));
      }

      final response = await _dio.post(
        ApiConfig.uploadFileMobile,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final List<dynamic> uploaded = response.data['files'];
      return uploaded.map((e) => e['fileUrl'] as String).toList();
    } catch (e) {
      print("${AppStyles.failureIcon} [Upload] Lỗi upload file: $e");
      rethrow;
    }
  }
}
