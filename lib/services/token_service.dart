import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TokenService {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userInfoKey = 'user_info';

  static Future<void> saveTokens(
      String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    print("${AppStyles.greenPointIcon} Token mới đã được lưu: $accessToken");
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<void> saveUserInfo(String userInfoJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userInfoKey, userInfoJson);
  }

  static Future<String?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userInfoKey);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userInfoKey);
  }

  static Future<String?> getCurrentUserId() async {
    final userInfoJson = await getUserInfo();
    if (userInfoJson == null) return null;

    try {
      final data = jsonDecode(userInfoJson);
      return data['userId'];
    } catch (e) {
      print("${AppStyles.failureIcon}Lỗi khi decode user info: $e");
      return null;
    }
  }

  static Future<String?> getCurrentUserAvatar() async {
    final userInfoJson = await getUserInfo();
    if (userInfoJson == null) return null;

    try {
      final data = jsonDecode(userInfoJson);
      return data['avatar'];
    } catch (e) {
      print("${AppStyles.failureIcon}Lỗi khi decode user info: $e");
      return null;
    }
  }

  static Future<String?> getCurrentUserName() async {
    final userInfoJson = await getUserInfo();
    if (userInfoJson == null) return null;

    try {
      final data = jsonDecode(userInfoJson);
      return data['displayName'] ?? data['name'];
    } catch (e) {
      print("${AppStyles.failureIcon} Lỗi khi lấy tên người dùng: $e");
      return null;
    }
  }

}
