class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String senderId;
  final String receiverId;
  final String type;
  final bool read;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      type: json['type'],
      read: json['read'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
