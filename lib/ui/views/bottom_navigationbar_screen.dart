import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/views/feed_screen.dart';
import 'package:olachat_mobile/ui/views/notifications_screen.dart';
import 'package:olachat_mobile/ui/views/my_profile_screen.dart';
import 'package:olachat_mobile/ui/views/search_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int currentTab = 0;
  final List<Widget> screens = [
    FeedScreen(),
    SearchScreen(),
    NotificationsScreen(),
    MyProfileScreen()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = FeedScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: PageStorage(bucket: bucket, child: currentScreen),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentTab,
        onTap: (index) {
          setState(() {
            currentTab = index;
            currentScreen = screens[index];
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_outlined),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "",
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 20,
        backgroundColor: Colors.white,
      ),
    ));
  }
}
