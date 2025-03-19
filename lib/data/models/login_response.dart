class LoginResponse {
  final int code;
  final String message;
  final String accessToken;
  final Map<String, dynamic> user;

  LoginResponse({
    required this.code,
    required this.message,
    required this.accessToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json["code"],
      message: json["message"],
      accessToken: json["data"]["accessToken"],
      user: json["data"]["user"],
    );
  }
}
