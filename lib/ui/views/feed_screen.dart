import 'package:flutter/material.dart';
import 'package:olachat_mobile/models/post_model.dart';
import 'package:olachat_mobile/models/user_model.dart';
import 'package:olachat_mobile/ui/widgets/custom_sliver_to_box_adapter.dart';
import 'package:olachat_mobile/ui/widgets/list_post.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header_two.dart';

import 'form_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<PostModel> posts = [
    PostModel(
      user: UserModel(
        avatarUrl:
            "https://netizenturkey.net/wp-content/uploads/2023/12/1703066681-20231220-gdragon.jpg",
        userName: "G-Dragon",
        nickName: "Anh Long !!!",
      ),
      postTime: "7 hours ago",
      postContent: "Bài viết của G-Dragon về âm nhạc!",
      likeCount: 270,
      dislikeCount: 15,
    ),
    PostModel(
      user: UserModel(
        avatarUrl:
            "https://netizenturkey.net/wp-content/uploads/2023/12/1703066681-20231220-gdragon.jpg",
        userName: "G-Dragon",
        nickName: "Anh Long !!!",
      ),
      postTime: "7 hours ago",
      postContent: "Bài viết của G-Dragon về âm nhạc!",
      likeCount: 270,
      dislikeCount: 15,
    ),
    PostModel(
      user: UserModel(
        avatarUrl:
            "https://netizenturkey.net/wp-content/uploads/2023/12/1703066681-20231220-gdragon.jpg",
        userName: "G-Dragon",
        nickName: "Anh Long !!!",
      ),
      postTime: "7 hours ago",
      postContent: "Bài viết của G-Dragon về âm nhạc!",
      likeCount: 270,
      dislikeCount: 15,
    ),
    PostModel(
      user: UserModel(
        avatarUrl:
            "https://netizenturkey.net/wp-content/uploads/2023/12/1703066681-20231220-gdragon.jpg",
        userName: "G-Dragon",
        nickName: "Anh Long !!!",
      ),
      postTime: "7 hours ago",
      postContent: "Bài viết của G-Dragon về âm nhạc!",
      likeCount: 270,
      dislikeCount: 15,
    ),
    PostModel(
      user: UserModel(
        avatarUrl:
            "https://netizenturkey.net/wp-content/uploads/2023/12/1703066681-20231220-gdragon.jpg",
        userName: "G-Dragon",
        nickName: "Anh Long !!!",
      ),
      postTime: "7 hours ago",
      postContent: "Bài viết của G-Dragon về âm nhạc!",
      likeCount: 270,
      dislikeCount: 15,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // View 1 - Header
          AppLogoHeaderTwo(),
          CustomSliverToBoxAdapter(),

          //   View 2 - Post
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FormPostScreen()),
                  );
                },
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        "https://netizenturkey.net/wp-content/uploads/2023/12/1703066681-20231220-gdragon.jpg",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Bạn đang nghĩ gì, chia sẻ ngay?",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          CustomSliverToBoxAdapter(),

          // View 3 - List Post
          ListPost(
            posts: posts,
            showCommentButton: true,
          )
        ],
      ),
    );
  }
}
