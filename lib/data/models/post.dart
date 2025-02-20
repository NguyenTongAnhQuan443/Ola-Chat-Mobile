import 'package:olachat_mobile/data/models/user.dart';

class Post {
  final User user;
  final String postTime;
  final String postContent;
  int likeCount;
  int dislikeCount;

  Post({
    required this.user,
    required this.postTime,
    required this.postContent,
    required this.likeCount,
    required this.dislikeCount,
  });
}
