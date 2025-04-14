class UserResponse {
  final String userId;
  final String email;
  final String username;
  final String displayName;
  final String nickname;
  final String avatar;
  final String bio;
  final DateTime dob;
  final String status;
  final String authProvider;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String role;

  UserResponse({
    required this.userId,
    required this.email,
    required this.username,
    required this.displayName,
    required this.nickname,
    required this.avatar,
    required this.bio,
    required this.dob,
    required this.status,
    required this.authProvider,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      userId: json['userId'],
      email: json['email'],
      username: json['username'],
      displayName: json['displayName'],
      nickname: json['nickname'],
      avatar: json['avatar'],
      bio: json['bio'],
      dob: DateTime.parse(json['dob']),
      status: json['status'],
      authProvider: json['authProvider'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      role: json['role'],
    );
  }
}
