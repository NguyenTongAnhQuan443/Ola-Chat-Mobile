import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

class FileUploadService {
  // Hàm upload từng file một (individually)
  // Trả về danh sách URL sau khi upload thành công
  static Future<List<String>> uploadFilesIndividually(
      List<PlatformFile> files, String accessToken) async {
    final Dio dio = Dio();
    final List<String> mediaUrls = [];

    // Lặp qua từng file được chọn
    for (final file in files) {
      // Xác định kiểu MIME từ path của file (ví dụ: image/png, video/mp4,...)
      final mimeType = lookupMimeType(file.path!) ?? 'application/octet-stream';
      final isVideo = mimeType.startsWith('video');
      final isImage = mimeType.startsWith('image'); // (hiện tại chưa dùng đến)

      // Tạo FormData để gửi lên server (giống như multipart/form-data)
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path!, // Đường dẫn file
          filename: file.name, // Tên file
          contentType: MediaType.parse(mimeType), // Gán kiểu nội dung
        ),
      });

      try {
        // Gọi API upload (POST) tới endpoint được định nghĩa trong ApiConfig
        final response = await dio.post(
          ApiConfig.upFile,
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken', // Đính kèm token để xác thực
              'Content-Type': 'multipart/form-data',
            },
          ),
        );

        // Nếu upload thành công và có trường fileUrl → thêm vào kết quả
        if (response.statusCode == 200 && response.data['fileUrl'] != null) {
          final uploadedUrl = response.data['fileUrl'];
          mediaUrls.add(uploadedUrl);
        } else {
          // Nếu server không trả về URL hợp lệ
          print(
              "${AppStyles.failureIcon} [FileUploadService] Upload thất bại: ${file.name} | Response: ${response.data}");
        }
      } on DioException catch (dioError) {
        print(
            "${AppStyles.failureIcon} [FileUploadService] DioError khi upload file ${file.name}: ${dioError.message}");
        print("${AppStyles.failureIcon} [FileUploadService] Response: ${dioError.response?.data}");
        print(
            "${AppStyles.failureIcon} [FileUploadService] Status: ${dioError.response?.statusCode}");
      } catch (e) {
        print(
            "${AppStyles.failureIcon} [FileUploadService] Lỗi không xác định khi upload file ${file.name}: $e");
      }
    }

    // Trả về danh sách URL sau khi upload xong tất cả
    return mediaUrls;
  }
}
