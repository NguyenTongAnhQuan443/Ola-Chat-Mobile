import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/utils/config/api_config.dart';
import 'token_service.dart';

class FileUploadService {
  static Future<List<String>> uploadFilesIndividually(
      List<PlatformFile> files, String accessToken) async {
    final Dio dio = Dio();
    final List<String> mediaUrls = [];

    for (final file in files) {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path!, filename: file.name),
      });

      try {
        final response = await dio.post(
          ApiConfig.upFile,
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'multipart/form-data',
            },
          ),
        );

        if (response.statusCode == 200 && response.data['fileUrl'] != null) {
          mediaUrls.add(response.data['fileUrl']);
        } else {
          throw Exception('❌ Upload failed for ${file.name}');
        }
      } catch (e) {
        print('❌ Error uploading ${file.name}: $e');
      }
    }

    return mediaUrls;
  }
}