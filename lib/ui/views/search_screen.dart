import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/widgets/custom_sliver_to_box_adapter.dart';
import 'package:olachat_mobile/ui/widgets/social_header.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Map<String, String>> notifications = [
    {
      "name": "Song Jong Ki",
      "description": "Bạn bè",
      "time": "1m",
      "image":
          "https://images.lifestyleasia.com/wp-content/uploads/sites/7/2025/02/05095531/Untitled-design-2025-02-05T095444.669-1600x900.jpg"
    },
    {
      "name": "Song Hye Kyo",
      "description": "Bạn bè",
      "time": "2d",
      "image":
          "https://icdn.24h.com.vn/upload/1-2025/images/2025-02-13//1739410199-song-hye-kyo-di-lam-mac-kin-dao-bao-nhieu-la-o-nha-phong-khoang-bay-nhieu-_0_5_n-5204-441-width780height975.jpg"
    },
    {
      "name": "Jeon Yeo-Been",
      "description": "Bạn bè",
      "time": "10w",
      "image":
          "https://static.wikia.nocookie.net/the-dramas/images/6/63/Yeobeen_-_Profile.jpg/revision/latest?cb=20240426014548"
    },
  ];

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // View 1 - Header
          SocialHeader(),
          CustomSliverToBoxAdapter(),

          //   View 2 - TextField Search
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                ),
              ),
            ),
          ),
          CustomSliverToBoxAdapter(),

          // View 3 - List Notification
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
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
                      trailing: Icon(Icons.arrow_forward_outlined),
                    ),
                  ),
                );
              },
              childCount: notifications.length,
            ),
          ),
        ],
      ),
    );
  }
}
