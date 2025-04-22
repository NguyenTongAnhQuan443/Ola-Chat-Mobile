class FriendRequestDTO {
  final String senderId;
  final String receiverId;

  FriendRequestDTO({required this.senderId, required this.receiverId});

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }

  factory FriendRequestDTO.fromJson(Map<String, dynamic> json) {
    return FriendRequestDTO(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
    );
  }
}
