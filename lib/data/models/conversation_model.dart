class ConversationModel {
  String id;
  String name;
  String avatarUrl;
  String lastMessage;
  bool isOnline;
  String type;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String> userIds;
  List<String> moderatorIds;
  String? adminId;
  String? backgroundUrl;

  ConversationModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.isOnline,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.userIds,
    required this.moderatorIds,
    this.adminId,
    this.backgroundUrl,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatar'] ?? '',
      lastMessage: json['lastMessage']?['content'] ?? '',
      isOnline: true, // Hardcode
      type: json['type'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      userIds: List<String>.from(json['userIds'] ?? []),
      moderatorIds: List<String>.from(json['moderatorIds'] ?? []),
      adminId: json['adminId'],
      backgroundUrl: json['backgroundUrl'],
    );
  }
}
