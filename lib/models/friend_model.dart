class FriendModel {
  final String userId;
  final String displayName;
  final String avatar;

  FriendModel({
    required this.userId,
    required this.displayName,
    required this.avatar,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      userId: json['userId'],
      displayName: json['displayName'],
      avatar: json['avatar'] ?? '',
    );
  }
}
