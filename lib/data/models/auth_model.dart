class AuthResponse {
  final String token;
  final bool authenticated;

  AuthResponse({required this.token, required this.authenticated});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      authenticated: json['authenticated'],
    );
  }
}
