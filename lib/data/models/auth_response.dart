class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final bool authenticated;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.authenticated,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      authenticated: json['authenticated'],
    );
  }
}
