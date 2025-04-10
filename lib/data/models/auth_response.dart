class AuthResponse {
  final String token;
  final String refreshToken;
  final bool authenticated;

  AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.authenticated,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    if (json['accessToken'] == null ||
        json['refreshToken'] == null ||
        json['authenticated'] == null) {
      throw Exception("Thông tin đăng nhập không hợp lệ.");
    }

    return AuthResponse(
      token: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      authenticated: json['authenticated'] as bool,
    );
  }
}
