import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/services/dio_client.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

class PostCreateViewModel extends ChangeNotifier {
  final Dio _dio = DioClient().dio;
  bool isPosting = false;

  Future<bool> createPost({
    required String content,
    required String privacy,
    required List<File> files,
  }) async {
    isPosting = true;
    notifyListeners();

    try {
      final formData = FormData();

      formData.fields
        ..add(MapEntry('content', content))
        ..add(MapEntry('privacy', privacy));

      for (var file in files) {
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
        ));
      }

      final response = await _dio.post(
        ApiConfig.base + "/api/posts",
        data: formData,
      );

      isPosting = false;
      notifyListeners();

      return response.statusCode == 200;
    } catch (e) {
      print("${AppStyles.failureIcon} Lỗi tạo bài viết: $e");
      isPosting = false;
      notifyListeners();
      return false;
    }
  }
}
