import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart'; // Bắt buộc để MediaType
import 'package:mime/mime.dart';
import '../../core/utils/config/api_config.dart';

class FileUploadService {
  static Future<List<String>> uploadFilesIndividually(
      List<PlatformFile> files, String accessToken) async {
    final Dio dio = Dio();
    final List<String> mediaUrls = [];

    print("🛠️ [UPLOAD] Tổng số file: ${files.length}");

    for (final file in files) {
      final mimeType = lookupMimeType(file.path!) ?? 'application/octet-stream';
      final isVideo = mimeType.startsWith('video');
      final isImage = mimeType.startsWith('image');

      print("📁 File: ${file.name} | MIME: $mimeType | "
          "Kích thước: ${(file.size / 1024).toStringAsFixed(1)} KB | "
          "${isVideo ? "🎥 VIDEO" : isImage ? "🖼️ ẢNH" : "📦 KHÁC"}");

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
          contentType: MediaType.parse(mimeType), // 👈 Rất quan trọng
        ),
      });

      try {
        print("🚀 [DIO] Chuẩn bị gửi request tới ${ApiConfig.upFile}");
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

        print("🎯 [DIO] Đã nhận response!");
        print("📩 STATUS CODE: ${response.statusCode}");
        print("📩 HEADERS: ${response.headers}");
        print("📩 RESPONSE DATA: ${response.data}");

        if (response.statusCode == 200 && response.data['fileUrl'] != null) {
          final uploadedUrl = response.data['fileUrl'];
          mediaUrls.add(uploadedUrl);
          print("✅ Upload thành công: $uploadedUrl");
        } else {
          print("❌ Upload thất bại: ${file.name} | Response: ${response.data}");
        }
      } on DioException catch (dioError) {
        print("❌ DioError khi upload file ${file.name}: ${dioError.message}");
        print("❌ Response: ${dioError.response?.data}");
        print("❌ Status: ${dioError.response?.statusCode}");
      } catch (e) {
        print("❌ Lỗi không xác định khi upload file ${file.name}: $e");
      }
    }

    print("📦 Tổng cộng upload thành công: ${mediaUrls.length} file");
    return mediaUrls;
  }
}
