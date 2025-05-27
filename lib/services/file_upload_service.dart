import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:olachat_mobile/config/api_config.dart';

class FileUploadService {
  static Future<List<String>> uploadFilesIndividually(
      List<PlatformFile> files, String accessToken) async {
    final Dio dio = Dio();
    final List<String> mediaUrls = [];

    for (final file in files) {
      final mimeType = lookupMimeType(file.path!) ?? 'application/octet-stream';
      final isVideo = mimeType.startsWith('video');
      final isImage = mimeType.startsWith('image');

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
          contentType: MediaType.parse(mimeType),
        ),
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
          final uploadedUrl = response.data['fileUrl'];
          mediaUrls.add(uploadedUrl);
        } else {
          print("Upload thất bại: ${file.name} | Response: ${response.data}");
        }
      } on DioException catch (dioError) {
        print("DioError khi upload file ${file.name}: ${dioError.message}");
        print("Response: ${dioError.response?.data}");
        print("Status: ${dioError.response?.statusCode}");
      } catch (e) {
        print("Lỗi không xác định khi upload file ${file.name}: $e");
      }
    }
    return mediaUrls;
  }
}
