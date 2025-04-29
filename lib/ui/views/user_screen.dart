import 'package:flutter/material.dart';
import 'package:olachat_mobile/data/models/post_model.dart';
import 'package:olachat_mobile/ui/views/settings_screen.dart';
import 'package:provider/provider.dart';

import '../../data/models/user_model.dart';
import '../../view_models/login_view_model.dart';
import '../widgets/custom_sliver_to_box_adapter.dart';
import '../widgets/list_post.dart';
import '../widgets/app_logo_header_two.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _MyProfileState();
}

class _MyProfileState extends State<UserScreen> {
  int selectedIndex = 0;

  List<PostModel> myPosts = [
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

  List<PostModel> savePosts = [
    PostModel(
      user: UserModel(
        avatarUrl:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Taeyang_-_MADE_THE_MOVIE_Premiere_%28cropped%29.jpg/640px-Taeyang_-_MADE_THE_MOVIE_Premiere_%28cropped%29.jpg",
        userName: "Taeyang",
        nickName: "Dong Young-bae",
      ),
      postTime: "5 hours ago",
      postContent: "Âm nhạc là cách duy nhất để kết nối tâm hồn! 🎶",
      likeCount: 350,
      dislikeCount: 10,
    ),
    PostModel(
      user: UserModel(
        avatarUrl:
            "https://media.vov.vn/sites/default/files/styles/large/public/2024-10/11-30-15-psy.jpg",
        userName: "PSY",
        nickName: "Oppa Gangnam Style",
      ),
      postTime: "8 hours ago",
      postContent: "Hãy cứ nhảy hết mình, không cần lo lắng! 🕺💃",
      likeCount: 500,
      dislikeCount: 20,
    ),
    PostModel(
      user: UserModel(
        avatarUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMCg9CVZdmUaQIzbQYFYsn9y1pEaDac7xBZwOF107RYtSIW3h0MstrlkUWAKY39SGGuAo&usqp=CAU",
        userName: "Zico",
        nickName: "Woo Ji-ho",
      ),
      postTime: "3 hours ago",
      postContent: "Tôi viết nhạc không chỉ để nghe mà còn để cảm nhận! 🎤🔥",
      likeCount: 420,
      dislikeCount: 15,
    ),
    PostModel(
      user: UserModel(
        avatarUrl:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Kim_Jennie_%28%EA%B9%80%EC%A0%9C%EB%8B%88%29_05.jpg/250px-Kim_Jennie_%28%EA%B9%80%EC%A0%9C%EB%8B%88%29_05.jpg",
        userName: "Jennie",
        nickName: "Solo Queen",
      ),
      postTime: "2 hours ago",
      postContent: "Hãy luôn tự tin và sống thật với chính mình! 💖✨",
      likeCount: 600,
      dislikeCount: 25,
    ),
    PostModel(
      user: UserModel(
        avatarUrl:
            "https://images2.thanhnien.vn/528068263637045248/2023/8/31/bts01-16934921040991899287129.jpg",
        userName: "RM",
        nickName: "Leader BTS",
      ),
      postTime: "1 hour ago",
      postContent: "Hãy học hỏi từ mọi khoảnh khắc, dù nhỏ bé nhất! 📖💡",
      likeCount: 720,
      dislikeCount: 30,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      Provider.of<LoginViewModel>(context, listen: false).refreshUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          AppLogoHeaderTwo(),
          CustomSliverToBoxAdapter(),
          SliverToBoxAdapter(
            child: Consumer<LoginViewModel>(
              builder: (context, vm, _) {
                final userInfo = vm.userInfo;
                return Container(
                  height: 271,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 326,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: userInfo?['avatar'] != null
                                  ? NetworkImage(userInfo!['avatar'])
                                  : const AssetImage(
                                          "assets/images/default_avatar.png")
                                      as ImageProvider,
                            ),
                            SizedBox(
                              width: 187,
                              height: 45,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  buildStatBox("12", "Posts"),
                                  buildStatBox("207", "Followers"),
                                  buildStatBox("64", "Following"),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 326,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  userInfo?['displayName'] ?? "Tên người dùng",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  userInfo?['nickname'] ?? "Biệt danh",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                              child: Text(
                                userInfo?['bio'] ?? "",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildIconButton(
                              0, Icons.grid_view_outlined, selectedIndex,
                              (index) {
                            setState(() => selectedIndex = index);
                          }),
                          buildIconButton(
                              1, Icons.bookmark_border, selectedIndex, (index) {
                            setState(() => selectedIndex = index);
                          }),
                          buildIconButton(2, Icons.settings, selectedIndex,
                              (index) {
                            setState(() => selectedIndex = index);
                          }),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          CustomSliverToBoxAdapter(),
          buildView_3(selectedIndex, myPosts, savePosts),
        ],
      ),
    );
  }
}

Widget buildStatBox(String count, String label) {
  return Column(
    children: [
      Text(count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ],
  );
}

Widget buildIconButton(
    int index, IconData icon, int selectedIndex, Function(int) onTap) {
  return IconButton(
    icon: Icon(icon,
        size: 20, color: selectedIndex == index ? Colors.blue : Colors.black54),
    onPressed: () => onTap(index),
  );
}

Widget buildView_3(
    int selectedIndex, List<PostModel> myPosts, List<PostModel> savePosts) {
  switch (selectedIndex) {
    case 0:
      return ListPost(posts: myPosts, showCommentButton: true);
    case 1:
      return ListPost(posts: savePosts, showCommentButton: true);
    case 2:
      return const SliverToBoxAdapter(child: SettingsScreen());
    default:
      return const SizedBox.shrink();
  }
}
