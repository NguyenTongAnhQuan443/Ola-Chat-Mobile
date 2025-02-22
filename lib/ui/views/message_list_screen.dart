import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/widgets/custom_sliver_to_box_adapter.dart';
import 'package:olachat_mobile/ui/widgets/social_header.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  final List<Map<String, String>> messages = [
    {
      'name': 'Kim Taehyung (V)',
      'message':
          'Chào bạn! Mình vừa xem ảnh mới nhất của bạn. Bạn trông đẹp trai quá! Chúng ta gặp nhau sớm nhé!',
      'avatarUrl':
          'https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2022/4/15/1034501/BTS-V-6.jpg',
    },
    {
      'name': 'Jennie Kim',
      'message':
          'Oppa ơi, bạn ngày càng đẹp trai! Cuối tuần này đi chơi cùng mình nhé!',
      'avatarUrl':
          'https://kenh14cdn.com/203336854389633024/2023/10/10/photo-14-16969313895451646555065.jpg',
    },
    {
      'name': 'Park Jimin',
      'message':
          'Wow, bạn trông thật rạng rỡ! Chúng ta gặp nhau đi, mình nhớ bạn lắm!',
      'avatarUrl':
          'https://kenh14cdn.com/2019/8/30/jimin-156714084317619046715.jpg',
    },
    {
      'name': 'IU (Lee Ji-eun)',
      'message':
          'Bạn trông thật tuyệt vời! Đi uống cà phê và trò chuyện một chút nhé!',
      'avatarUrl':
          'https://photo.znews.vn/w660/Uploaded/qfssu/2022_12_31/IU_CNP_Laboratory_.jpeg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            // View 1 - Header
            SocialHeader(),
            CustomSliverToBoxAdapter(),

            // View 2 - New Message
            SliverToBoxAdapter(
              child: Container(
                height: 54,
                color: Colors.white,
                child: TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.create_outlined,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'New Message',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54, // Chữ màu đen
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            CustomSliverToBoxAdapter(),

            // View 3 - Messages List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final message = messages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(message['avatarUrl']!),
                      ),
                      title: Text(
                        message['name']!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        message['message']!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {},
                    ),
                  );
                },
                childCount: messages.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
