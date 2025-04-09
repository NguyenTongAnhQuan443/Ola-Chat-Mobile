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
    return AuthResponse(
      token: json['accessToken'],
      refreshToken: json['refreshToken'],
      authenticated: json['authenticated'],
    );
  }
}
