class ConversationModel {
  final String id;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final bool isOnline;

  ConversationModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.isOnline,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Không tên',
      avatarUrl: json['avatar'] ?? '',
      lastMessage: json['lastMessage']?['content'] ?? '',
      isOnline: true, // tạm thời hardcode
    );
  }
}
