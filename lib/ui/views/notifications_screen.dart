import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/widgets/social_header.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, String>> notifications = [
    {
      "name": "Song Jong Ki",
      "description": "Start following you.",
      "time": "1m",
      "image":
          "https://images.lifestyleasia.com/wp-content/uploads/sites/7/2025/02/05095531/Untitled-design-2025-02-05T095444.669-1600x900.jpg"
    },
    {
      "name": "Song Hye Kyo",
      "description": "Liked your post.",
      "time": "2d",
      "image":
          "https://icdn.24h.com.vn/upload/1-2025/images/2025-02-13//1739410199-song-hye-kyo-di-lam-mac-kin-dao-bao-nhieu-la-o-nha-phong-khoang-bay-nhieu-_0_5_n-5204-441-width780height975.jpg"
    },
    {
      "name": "Jeon Yeo-been",
      "description": "Commented on your post.",
      "time": "10w",
      "image":
          "https://static.wikia.nocookie.net/the-dramas/images/6/63/Yeobeen_-_Profile.jpg/revision/latest?cb=20240426014548"
    },
  ];

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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                var notification = notifications[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(notification["image"]!),
                      ),
                      title: Text(
                        notification["name"]!,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(notification["description"]!),
                      trailing: Text(
                        notification["time"]!,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
              childCount: notifications.length,
            ),
          )
        ],
      ),
    );
  }
}
