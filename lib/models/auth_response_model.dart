class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final bool authenticated;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.authenticated,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      authenticated: json['authenticated'],
    );
  }
}
