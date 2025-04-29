import 'package:olachat_mobile/data/models/user_model.dart';

class PostModel {
  final UserModel user;
  final String postTime;
  final String postContent;
  int likeCount;
  int dislikeCount;

  PostModel({
    required this.user,
    required this.postTime,
    required this.postContent,
    required this.likeCount,
    required this.dislikeCount,
  });
}
