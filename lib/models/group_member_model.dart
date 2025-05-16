class GroupMemberModel {
  final String userId;
  final String displayName;
  final String? avatar;
  final String role; // ADMIN, MODERATOR, MEMBER
  final String status;

  GroupMemberModel({
    required this.userId,
    required this.displayName,
    required this.avatar,
    required this.role,
    required this.status,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) {
    return GroupMemberModel(
      userId: json['userId'],
      displayName: json['displayName'],
      avatar: json['avatar'],
      role: json['role'],
      status: json['status'],
    );
  }
}
