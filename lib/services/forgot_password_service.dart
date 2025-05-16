import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/services/dio_client.dart';

class ForgotPasswordService {
  final Dio _dio = DioClient().dio;

  Future<void> sendOtp(String email) async {
    final response = await _dio.post(
      "${ApiConfig.authForgotPassword}?email=$email",
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      return;
    } else {
      throw Exception(response.data['message'] ?? 'Gửi OTP thất bại');
    }
  }
}
