import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/config/api_config.dart';

class UserService {
  Future<void> uploadAvatar(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final uri = Uri.parse(ApiConfig.updateAvatar); // /users/my-avatar
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
}
