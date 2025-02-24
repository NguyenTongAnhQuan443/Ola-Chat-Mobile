import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/widgets/custom_sliver_to_box_adapter.dart';
import 'package:olachat_mobile/ui/widgets/social_header.dart';

import '../../data/models/post.dart';
import '../../data/models/user.dart';
import '../widgets/list_post.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<Post> posts = [
    Post(
      user: User(
        avatarUrl:
            "https://netizenturkey.net/wp-content/uploads/2023/12/1703066681-20231220-gdragon.jpg",
        userName: "G-Dragon",
        nickName: "Anh Long !!!",
      ),
      postTime: "7 hours ago",
      postContent:
          "À, cái hôm đó mà bảo mình rap dis MAMA, thật ra là mình chỉ muốn nói: ‘Chắc các bạn không hiểu đâu, nhưng tôi chỉ đang... cho các bạn thấy một chút 'tình yêu' thôi mà!’ 사실, 나는 그냥 사랑을 보여주고 싶었어 😎🎤",
      likeCount: 270,
      dislikeCount: 15,
    ),
  ];

  final List<Map<String, String>> comments = [
    {
      "name": "Sơn Tùng - MTP",
      "comment": "MAMA gọi anh bằng điện thoại :v",
      "avatarUrl":
          "https://cdn-media.sforum.vn/storage/app/media/thanhhuyen/%E1%BA%A3nh%20s%C6%A1n%20t%C3%B9ng%20mtp/anh-son-tung-mtp-thumb.jpg"
    },
    {
      "name": "Sobin Hoàng Sơn",
      "comment": "Anh Long mãi đỉnhhhh 🐧",
      "avatarUrl":
          "https://photo.znews.vn/w660/Uploaded/qfssu/2024_08_09/449848825_1045702913582606_2575891357318997780_n.jpg"
    },
    {
      "name": "Chi Dân",
      "comment": "Comback đi anh ơiiii .",
      "avatarUrl":
          "https://media-cdn-v2.laodong.vn/storage/newsportal/2024/11/10/1419511/Chidan.jpg"
    },
    {
      "name": "Lê Dương Bảo Lâm",
      "comment": "Quá đãaaaa",
      "avatarUrl":
          "https://cdn.tuoitre.vn/thumb_w/480/471584752817336320/2023/2/14/le-duong-bao-lam-16763797843941535506737.jpg"
    },
  ];

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // View - Header
                SocialHeader(),
                CustomSliverToBoxAdapter(),

                // View - Post
                ListPost(posts: posts, showCommentButton: false),
                CustomSliverToBoxAdapter(),

                // View - Comment
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        child: Card(
                          color: Color(0xFFF1F4F9),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundImage: NetworkImage(
                                        comments[index]["avatarUrl"]!,
                                      ),
                                      onBackgroundImageError: (_, __) =>
                                          Icon(Icons.error),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      comments[index]["name"]!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  comments[index]["comment"]!,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.thumb_up_alt_outlined),
                                      onPressed: () {},
                                    ),
                                    Text("39"),
                                    SizedBox(width: 10),
                                    IconButton(
                                      icon: Icon(Icons.comment_outlined),
                                      onPressed: () {},
                                    ),
                                    Text("1"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: comments.length,
                  ),
                ),
              ],
            ),
          ),

          // View Comment Input Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    "https://kalbaronline.com/wp-content/uploads/2024/10/GD.jpg",
                  ),
                  onBackgroundImageError: (_, __) => Icon(Icons.error),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Handle the comment submission
                    String comment = _commentController.text;
                    if (comment.isNotEmpty) {
                      setState(() {
                        comments.add({
                          "name": "Your Name",
                          "comment": comment,
                          "avatarUrl": "your_avatar_url"
                        });
                        _commentController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
