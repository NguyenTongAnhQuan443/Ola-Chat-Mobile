class FriendRequestModel {
  final String senderId;
  final String receiverId;

  FriendRequestModel({required this.senderId, required this.receiverId});

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
    );
  }
}
