import 'package:olachat_mobile/data/models/user.dart';

class PostModel {
  final User user;
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
