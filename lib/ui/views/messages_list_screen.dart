import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/widgets/custom_sliver_to_box_adapter.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header_two.dart';

import 'messages_conversation_screen.dart';

class MessagesListScreen extends StatefulWidget {
  const MessagesListScreen({super.key});

  @override
  State<MessagesListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessagesListScreen> {
  final List<Map<String, String>> messages = [
    {
      'name': 'Kim Taehyung (V)',
      'message':
          'Chào bạn! Mình vừa xem ảnh mới nhất của bạn. Bạn trông đẹp trai quá! Chúng ta gặp nhau sớm nhé!',
      'avatarUrl':
          'https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2022/4/15/1034501/BTS-V-6.jpg',
      "status": "online"
    },
    {
      'name': 'Jennie Kim',
      'message':
          'Oppa ơi, bạn ngày càng đẹp trai! Cuối tuần này đi chơi cùng mình nhé!',
      'avatarUrl':
          'https://kenh14cdn.com/203336854389633024/2023/10/10/photo-14-16969313895451646555065.jpg',
      "status": "online"
    },
    {
      'name': 'Park Jimin',
      'message':
          'Wow, bạn trông thật rạng rỡ! Chúng ta gặp nhau đi, mình nhớ bạn lắm!',
      'avatarUrl':
          'https://kenh14cdn.com/2019/8/30/jimin-156714084317619046715.jpg',
      "status": "offline"
    },
    {
      'name': 'IU (Lee Ji-eun)',
      'message':
          'Bạn trông thật tuyệt vời! Đi uống cà phê và trò chuyện một chút nhé!',
      'avatarUrl':
          'https://photo.znews.vn/w660/Uploaded/qfssu/2022_12_31/IU_CNP_Laboratory_.jpeg',
      "status": "online"
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
            AppLogoHeaderTwo(),
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
                          color: Colors.black54,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'New Message',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
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
                      child: InkWell(
                        child: ListTile(
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage:
                                    NetworkImage(message['avatarUrl']!),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 6,
                                  backgroundColor: message['status'] == 'online'
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ],
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MessagesConversationScreen(),
                              ),
                            );
                          },
                        ),
                      ));
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
