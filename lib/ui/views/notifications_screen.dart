import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header_two.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, String>> notifications = [
    {
      "name": "Lee Min Ho",
      "description": "Start following you.",
      "time": "1m",
      "image":
          "https://kenh14cdn.com/2016/4-1480306785639.png"
    },
    {
      "name": "kim soo-hyun ",
      "description": "Liked your post.",
      "time": "2d",
      "image":
          "https://cdn.shopify.com/s/files/1/0469/3927/5428/files/adba30abc41c147e29a634078c8762e1.jpg?v=1723635440"
    },
    {
      "name": "Kim Ji Won ",
      "description": "Commented on your post.",
      "time": "10w",
      "image":
          "https://media-cdn-v2.laodong.vn/storage/newsportal/2024/4/30/1334046/Kim-Ji-Won-1B15.jpg?w=800&h=496&crop=auto&scale=both"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // View 1 - Header
          AppLogoHeaderTwo(),
          SliverToBoxAdapter(
            child: Container(
              height: 10,
              color: Colors.grey.shade100, // Set màu nền cho Container
              child: const SizedBox(height: 10), // Nội dung của bạn
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
