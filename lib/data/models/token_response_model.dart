import 'package:dio/dio.dart';

import '../../core/utils/config/api_config.dart';

class TokenResponseModel {
  final String accessToken;
  final String refreshToken;

  TokenResponseModel({required this.accessToken, required this.refreshToken});

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) {
    return TokenResponseModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}

Future<TokenResponseModel?> refreshAccessToken(String accessTokenOld, String refreshToken) async {
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
      return TokenResponseModel.fromJson(data);
    } else {
      return null;
    }
  } catch (e) {
    print('Refresh token failed: $e');
    return null;
  }
}
