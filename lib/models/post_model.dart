class PostModel {
  final int postId;
  final String postContent;
  final String postTime;
  final UserModel user;
  final List<String> attachments;

  PostModel({
    required this.postId,
    required this.postContent,
    required this.postTime,
    required this.user,
    required this.attachments,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'],
      postContent: json['content'],
      postTime: json['createdAt'],
      user: UserModel.fromJson(json['createdBy']),
      attachments: (json['attachments'] as List)
          .map((item) => item['fileUrl'] as String)
          .toList(),
    );
  }
}

class UserModel {
  final String userId;
  final String userName;
  final String avatarUrl;

  UserModel({
    required this.userId,
    required this.userName,
    required this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      userName: json['displayName'] ?? '',
      avatarUrl: json['avatar'] ?? '',
    );
  }
}
