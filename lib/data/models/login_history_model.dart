class LoginHistoryModel {
  final String loginTime;
  final String? logoutTime;
  final String status;
  final String userAgent;

  LoginHistoryModel({
    required this.loginTime,
    this.logoutTime,
    required this.status,
    required this.userAgent,
  });

  factory LoginHistoryModel.fromJson(Map<String, dynamic> json) {
    return LoginHistoryModel(
      loginTime: json['loginTime'],
      logoutTime: json['logoutTime'],
      status: json['status'],
      userAgent: json['userAgent'],
    );
  }
}
