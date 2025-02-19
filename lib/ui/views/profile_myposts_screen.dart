import 'package:flutter/material.dart';

import '../widgets/social_header.dart';

class ProfileMyPostsScreen extends StatefulWidget {
  const ProfileMyPostsScreen({super.key});

  @override
  State<ProfileMyPostsScreen> createState() => _ProfileMyPostsScreenState();
}

class _ProfileMyPostsScreenState extends State<ProfileMyPostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // View 1 - Header
          SocialHeader(),
          SliverToBoxAdapter(
            child: Container(
              height: 10,
              color: Colors.grey.shade100, // Set màu nền cho Container
              child: SizedBox(height: 10), // Nội dung của bạn
            ),
          ),

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
          SliverToBoxAdapter(
            child: Container(
              height: 10,
              color: Colors.grey.shade100, // Set màu nền cho Container
              child: SizedBox(height: 10), // Nội dung của bạn
            ),
          ),

          // View 3 - List Post

        ],
      ),
    );
  }
}
