import '../enum/message_type.dart';

class MessageModel {
  final String? id;
  final String senderId;
  final String conversationId;
  final String content;
  final MessageType type;
  final List<String>? mediaUrls;
  final String? status;
  final List<Map<String, dynamic>>? deliveryStatus;
  final List<Map<String, dynamic>>? readStatus;
  final DateTime? createdAt;
  final bool recalled;
  final List<Map<String, dynamic>>? mentions;

  MessageModel({
    this.id,
    required this.senderId,
    required this.conversationId,
    required this.content,
    required this.type,
    this.mediaUrls,
    this.status,
    this.deliveryStatus,
    this.readStatus,
    this.createdAt,
    required this.recalled,
    this.mentions,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['senderId'] ?? '',
      conversationId: json['conversationId'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] != null
          ? MessageType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => MessageType.TEXT,
      )
          : MessageType.TEXT,
      mediaUrls: json['mediaUrls'] != null
          ? List<String>.from(json['mediaUrls'])
          : null,
      status: json['status'],
      deliveryStatus: json['deliveryStatus'] != null
          ? List<Map<String, dynamic>>.from(json['deliveryStatus'])
          : null,
      readStatus: json['readStatus'] != null
          ? List<Map<String, dynamic>>.from(json['readStatus'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      recalled: json['recalled'] ?? false,
      mentions: json['mentions'] != null
          ? List<Map<String, dynamic>>.from(json['mentions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'conversationId': conversationId,
      'content': content,
      'type': type.name,
      'mediaUrls': mediaUrls,
      'status': status,
      'deliveryStatus': deliveryStatus,
      'readStatus': readStatus,
      'createdAt': createdAt?.toIso8601String(),
      'recalled': recalled,
      'mentions': mentions,
    };
  }
}
