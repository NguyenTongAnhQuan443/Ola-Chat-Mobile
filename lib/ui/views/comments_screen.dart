import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/widgets/custom_sliver_to_box_adapter.dart';
import 'package:olachat_mobile/ui/widgets/social_header.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final List<Map<String, String>> comments = [
    {
      "name": "Nguyễn Anh Khoa",
      "comment": "Bạn có bán khóa học giải thuật không?",
    },
    {
      "name": "Hoàng Nguyễn",
      "comment": "Bán j khai mau 🐧",
    },
    {
      "name": "Nguyễn Thương",
      "comment": "không dám lộ diện sợ bị chửi .",
    },
    {
      "name": "Lư Hậu",
      "comment": "Xin cái địa chỉ",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SocialHeader(),
          CustomSliverToBoxAdapter(),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.grey[300],
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
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
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87),
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
    ));
  }
}
