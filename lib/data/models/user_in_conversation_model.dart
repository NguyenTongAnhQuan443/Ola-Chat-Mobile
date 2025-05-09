class UserInConversation {
  final String userId;
  final String displayName;
  final String avatar;

  UserInConversation({
    required this.userId,
    required this.displayName,
    required this.avatar,
  });

  factory UserInConversation.fromJson(Map<String, dynamic> json) {
    return UserInConversation(
      userId: json['userId'],
      displayName: json['displayName'],
      avatar: json['avatar'] ?? '',
    );
  }
}
