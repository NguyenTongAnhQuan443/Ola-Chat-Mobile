class UserResponseModel {
  final String userId;
  final String email;
  final String displayName;
  final String? nickname;
  final String avatar;
  final String? bio;
  final String dob;
  final String friendAction;

  UserResponseModel({
    required this.userId,
    required this.email,
    required this.displayName,
    this.nickname,
    required this.avatar,
    this.bio,
    required this.dob,
    required this.friendAction,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      nickname: json['nickname'],
      avatar: json['avatar'] ?? '',
      bio: json['bio'],
      dob: json['dob'] ?? '',
      friendAction: json['friendAction'] ?? '',
    );
  }
}
