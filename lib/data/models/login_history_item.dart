class LoginHistoryItem {
  final String loginTime;
  final String? logoutTime;
  final String status;
  final String userAgent;

  LoginHistoryItem({
    required this.loginTime,
    this.logoutTime,
    required this.status,
    required this.userAgent,
  });

  factory LoginHistoryItem.fromJson(Map<String, dynamic> json) {
    return LoginHistoryItem(
      loginTime: json['loginTime'],
      logoutTime: json['logoutTime'],
      status: json['status'],
      userAgent: json['userAgent'],
    );
  }
}
