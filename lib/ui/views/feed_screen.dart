import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/widgets/custom_sliver_to_box_adapter.dart';
import 'package:olachat_mobile/ui/widgets/list_post.dart';
import 'package:olachat_mobile/ui/widgets/social_header.dart';

import '../../data/models/post_model.dart';
import '../../data/models/user.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<PostModel> posts = [
    PostModel(
      user: User(
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
      user: User(
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
      user: User(
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
      user: User(
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
      user: User(
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
          SocialHeader(),
          CustomSliverToBoxAdapter(),

          //   View 2 - Post
          SliverToBoxAdapter(
            child: Container(
              height: 154,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              "https://netizenturkey.net/wp-content/uploads/2023/12/1703066681-20231220-gdragon.jpg"),
                          onBackgroundImageError: (_, __) =>
                              Icon(Icons.person_outline),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                            child: TextField(
                          decoration: InputDecoration(
                              hintText: "What's on your mind?",
                              // border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.grey.shade600)),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                          child: TextButton.icon(
                            onPressed: () {},
                            label: Text(
                              "Add Media",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            icon: const Icon(
                              Icons.image_outlined,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff4C68D5)),
                          child: const Text(
                            "Post",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          CustomSliverToBoxAdapter(),

          // View 3 - List Post
          ListPost(posts: posts, showCommentButton: true,)
        ],
      ),
    );
  }
}
