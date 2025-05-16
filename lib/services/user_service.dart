import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:olachat_mobile/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_response_model.dart';

class UserService {
  Future<void> uploadAvatar(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final uri = Uri.parse(ApiConfig.updateAvatar);
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('avatar', imageFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200 || json['success'] != true) {
      throw Exception(json['message'] ?? "Upload avatar thất bại.");
    }
  }

  Future<void> refreshUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse(ApiConfig.userInfo),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200 && data['success'] == true) {
      await prefs.setString('user_info', jsonEncode(data['data']));
    } else {
      throw Exception("Làm mới thông tin thất bại.");
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.put(
      Uri.parse(ApiConfig.updateProfile),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200 || json['success'] != true) {
      throw Exception(json['message'] ?? "Cập nhật thông tin thất bại.");
    }
  }

  Future<void> sendEmailOtp(String newEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final uri = Uri.parse("${ApiConfig.sendEmailUpdateOtp}?newEmail=$newEmail");
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception(data['message'] ?? "Gửi mã OTP email thất bại.");
    }
  }

  Future<void> verifyEmailOtp(String otp) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final uri = Uri.parse("${ApiConfig.verifyEmailUpdateOtp}?otp=$otp");
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception(data['message'] ?? "Xác minh OTP email thất bại.");
    }
  }

  // Tìm kiếm
  static Future<UserResponseModel?> search(String query, String token) async {
    final url = ApiConfig.searchUser(query);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final decoded = utf8.decode(response.bodyBytes);
    final data = jsonDecode(decoded);

    if (response.statusCode == 200 && data['data'] != null) {
      return UserResponseModel.fromJson(data['data']);
    }

    if (response.statusCode == 404 || data['message']?.contains("không tìm thấy") == true) {
      // Trả về null để ViewModel tự xử lý
      return null;
    }

    // Những lỗi khác vẫn ném ra
    throw Exception(data['message'] ?? 'Lỗi không xác định khi tìm kiếm người dùng');
  }

}
