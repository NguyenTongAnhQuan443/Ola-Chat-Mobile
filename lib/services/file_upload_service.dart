import 'dart:io';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'dio_client.dart';

class FileUploadService {
  final Dio _dio = DioClient().dio;

  Future<List<String>> uploadFiles(List<File> files) async {
    final formData = FormData();

    for (final file in files) {
      formData.files.add(MapEntry(
        'files',
        await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      ));
    }

    final response = await _dio.post(
      ApiConfig.uploadFileMobile, // endpoint bạn cung cấp
      data: formData,
    );

    final List<dynamic> uploaded = response.data['files'];
    return uploaded.map((e) => e['fileUrl'] as String).toList();
  }
}
