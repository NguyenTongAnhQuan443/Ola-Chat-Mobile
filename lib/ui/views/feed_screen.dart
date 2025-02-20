import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/views/comments_screen.dart';
import 'package:olachat_mobile/ui/widgets/custom_sliver_to_box_adapter.dart';
import 'package:olachat_mobile/ui/widgets/social_header.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<String> posts = List.generate(
      20,
      (index) =>
          "In today's fast-paced, digitally driven world, digital marketing is not just a strategy; it's a necessity for businesses of all sizes. - $index");

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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              "https://netizenturkey.net/wp-content/uploads/2023/12/1703066681-20231220-gdragon.jpg",
                            ),
                            onBackgroundImageError: (_, __) =>
                                Icon(Icons.error),
                          ),
                          title: Text(
                            "G-Dragon",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Anh Long !!!",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Icons.more_horiz, size: 20),
                              Text("7 hours ago",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          posts[index],
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CommentsScreen()));
                              },
                              icon: Icon(Icons.mode_comment_outlined,
                                  size: 20, color: Colors.grey),
                              label: Text("Comment",
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            Row(
                              children: [
                                Text("270 Likes",
                                    style: TextStyle(color: Colors.grey)),
                                const SizedBox(width: 8),
                                Icon(Icons.thumb_up_alt_outlined,
                                    size: 20, color: Colors.grey),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              childCount: posts.length,
            ),
          ),
        ],
      ),
    );
  }
}
