class LastMessageModel {
  final String content;
  final DateTime? createdAt;
  final String? senderId;

  LastMessageModel({
    required this.content,
    this.createdAt,
    this.senderId,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      content: json['content'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      senderId: json['senderId'],
    );
  }
}
