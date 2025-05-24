import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/services/dio_client.dart';
import 'package:olachat_mobile/services/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_response_model.dart';

class UserService {
  // Upload avatar

  Future<void> uploadAvatar(File imageFile) async {
    final token = await TokenService.getAccessToken();
    if (token == null) throw Exception('Token không tồn tại');

    final dio = DioClient().dio;
    final formData = FormData.fromMap({
      'avatar':
          await MultipartFile.fromFile(imageFile.path, filename: 'avatar.jpg'),
    });

    final response = await dio.put(
      ApiConfig.updateAvatar,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
        contentType: 'multipart/form-data',
      ),
    );

    final json = response.data;
    if (response.statusCode != 200 || json['success'] != true) {
      throw Exception(json['message'] ?? "Upload avatar thất bại.");
    }
  }

  // Refresh user info
  Future<void> refreshUserInfo() async {
    final token = await TokenService.getAccessToken();
    if (token == null) throw Exception('Token không tồn tại');

    final dio = DioClient().dio;
    final response = await dio.get(
      ApiConfig.userInfo,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    final data = response.data;
    if (response.statusCode == 200 && data['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'user_info', data['data'] != null ? data['data'].toString() : '');
    } else {
      throw Exception("Làm mới thông tin thất bại.");
    }
  }

  // Update profile
  Future<void> updateProfile(Map<String, dynamic> data) async {
    final token = await TokenService.getAccessToken();
    if (token == null) throw Exception('Token không tồn tại');

    final dio = DioClient().dio;
    final response = await dio.put(
      ApiConfig.updateProfile,
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    final json = response.data;
    if (response.statusCode != 200 || json['success'] != true) {
      throw Exception(json['message'] ?? "Cập nhật thông tin thất bại.");
    }
  }

  // Send email OTP
  Future<void> sendEmailOtp(String newEmail) async {
    final token = await TokenService.getAccessToken();
    if (token == null) throw Exception('Token không tồn tại');

    final dio = DioClient().dio;
    final uri = "${ApiConfig.sendEmailUpdateOtp}?newEmail=$newEmail";
    final response = await dio.post(
      uri,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = response.data;
    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception(data['message'] ?? "Gửi mã OTP email thất bại.");
    }
  }

  // Verify email OTP
  Future<void> verifyEmailOtp(String otp) async {
    final token = await TokenService.getAccessToken();
    if (token == null) throw Exception('Token không tồn tại');

    final dio = DioClient().dio;
    final uri = "${ApiConfig.verifyEmailUpdateOtp}?otp=$otp";
    final response = await dio.post(
      uri,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = response.data;
    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception(data['message'] ?? "Xác minh OTP email thất bại.");
    }
  }

  // Search User
  static Future<UserResponseModel?> search(String query, String token) async {
    final dio = DioClient().dio;
    try {
      final response = await dio.get(
        ApiConfig.searchUser(query),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      final data = response.data;

      if (response.statusCode == 200 && data['data'] != null) {
        return UserResponseModel.fromJson(data['data']);
      }

      if (response.statusCode == 404 ||
          (data['message']?.contains("không tìm thấy") == true)) {
        return null;
      }

      throw Exception(
          data['message'] ?? 'Lỗi không xác định khi tìm kiếm người dùng');
    } on DioException catch (e) {
      if (e.response != null &&
          (e.response!.statusCode == 404 ||
              e.response?.data['message']?.contains("không tìm thấy") ==
                  true)) {
        return null;
      }
      throw Exception(
          '[Dio] Lỗi khi tìm kiếm người dùng: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('[Dio] Lỗi khi tìm kiếm người dùng: $e');
    }
  }
}
