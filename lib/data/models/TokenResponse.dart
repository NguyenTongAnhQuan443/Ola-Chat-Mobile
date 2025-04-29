import 'package:dio/dio.dart';

import '../../core/utils/config/api_config.dart';

class TokenResponse {
  final String accessToken;
  final String refreshToken;

  TokenResponse({required this.accessToken, required this.refreshToken});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}

Future<TokenResponse?> refreshAccessToken(String accessTokenOld, String refreshToken) async {
  try {
    final dio = Dio();

    final response = await dio.post(
      ApiConfig.authRefresh,
      data: {
        "refreshToken": refreshToken,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessTokenOld',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data['data'];
      return TokenResponse.fromJson(data);
    } else {
      return null;
    }
  } catch (e) {
    print('Refresh token failed: $e');
    return null;
  }
}
