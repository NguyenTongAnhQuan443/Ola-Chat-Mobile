import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/services/dio_client.dart';

class ResetPasswordService {
  final Dio _dio = DioClient().dio;

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final response = await _dio.post(
      ApiConfig.authResetPassword,
      data: {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      },
    );

    if (response.statusCode != 200 || response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Đổi mật khẩu thất bại');
    }
  }
}
