import 'dart:io';
import 'package:dio/dio.dart';
import 'package:olachat_mobile/services/token_service.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import '../config/api_config.dart';
import 'dio_client.dart';
import 'package:http_parser/http_parser.dart';

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

  // Gửi Audio
  Future<String?> uploadAudioFile(File file) async {
    try {
      final accessToken = await TokenService.getAccessToken();

      final extension = file.path.toLowerCase().split('.').last;

      // Map đuôi file -> MediaType
      final mediaTypeMap = {
        'mp3': MediaType('audio', 'mpeg'),
        'wav': MediaType('audio', 'wav'),
        'm4a': MediaType('audio', 'mp4'),
        'aac': MediaType('audio', 'aac'),
        'ogg': MediaType('audio', 'ogg'),
        'wma': MediaType('audio', 'x-ms-wma'),
        'flac': MediaType('audio', 'flac'),
        'alac': MediaType('audio', 'alac'),
        'aiff': MediaType('audio', 'aiff'),
      };

      final contentType = mediaTypeMap[extension] ?? MediaType('application', 'octet-stream');

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: contentType,
        ),
      });

      final response = await _dio.post(
        ApiConfig.uploadAudio,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return response.data['data']['fileUrl'];
    } catch (e) {
      print("${AppStyles.failureIcon} Upload audio failed: $e");
      return null;
    }
  }

}
