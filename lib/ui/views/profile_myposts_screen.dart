import 'package:flutter/material.dart';

import '../widgets/custom_sliver_to_box_adapter.dart';
import '../widgets/social_header.dart';

class ProfileMyPostsScreen extends StatefulWidget {
  const ProfileMyPostsScreen({super.key});

  @override
  State<ProfileMyPostsScreen> createState() => _ProfileMyPostsScreenState();
}

class _ProfileMyPostsScreenState extends State<ProfileMyPostsScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // View 1 - Header
          SocialHeader(),
          CustomSliverToBoxAdapter(),

          //   View 2 - User
          SliverToBoxAdapter(
            child: Container(
              height: 271,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // View -> User - Posts - Followers - Following
                  Container(
                    width: 326,
                    height: 80,
                    color: Colors.yellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                                "https://netizenturkey.net/wp-content/uploads/2023/12/1703066681-20231220-gdragon.jpg")),
                        SizedBox(
                          width: 187,
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildStatBox("12", "Posts"),
                              buildStatBox("207", "Followers"),
                              buildStatBox("64", "Following")
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  // View -> UserName - NickName
                  Container(
                    width: 326,
                    color: Colors.yellow,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "G-Dragon",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "@anhLong_18_08",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                          child: Text(
                            "Nghệ Sĩ Nhân Dân",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),

                  // View -> Function
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildIconButton(
                          0, Icons.grid_view_outlined, selectedIndex, (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      }),
                      buildIconButton(1, Icons.bookmark_border, selectedIndex,
                          (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      }),
                      buildIconButton(2, Icons.settings, selectedIndex,
                          (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
          CustomSliverToBoxAdapter(),

          // View 3 - List Post
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              color: getViewColor(selectedIndex),
              // Thay đổi màu dựa trên icon được chọn
              alignment: Alignment.center,
              child: Text(
                getViewText(selectedIndex),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildStatBox(String count, String label) {
  return Column(
    children: [
      Text(
        count,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey),
      )
    ],
  );
}

Widget buildIconButton(
    int index, IconData icon, int selectedIndex, Function(int) onTap) {
  return IconButton(
    icon: Icon(icon,
        size: 20, color: selectedIndex == index ? Colors.blue : Colors.black54),
    onPressed: () {
      onTap(index);
    },
  );
}

Color getViewColor(int index) {
  switch (index) {
    case 0:
      return Colors.red;
    case 1:
      return Colors.green;
    case 2:
      return Colors.pink;
    default:
      return Colors.white;
  }
}

String getViewText(int index) {
  switch (index) {
    case 0:
      return "Màu Đỏ";
    case 1:
      return "Màu Xanh";
    case 2:
      return "Màu Hồng";
    default:
      return "Mặc định";
  }
}
