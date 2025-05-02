import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header_two.dart';
import 'package:olachat_mobile/view_models/notification_view_model.dart';
import 'all_notifications_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewModel()..fetchTopNotifications(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<NotificationViewModel>(
          builder: (context, vm, _) {
            return RefreshIndicator(
              onRefresh: vm.fetchTopNotifications,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  AppLogoHeaderTwo(),
                  SliverToBoxAdapter(child: Container(height: 10, color: Colors.grey.shade100)),

                  SliverToBoxAdapter(
                    child: sectionHeader(
                      title: "Thông báo mới",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AllNotificationsScreen()),
                        );
                      },
                    ),
                  ),

                  vm.isLoadingTop
                      ? const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  )
                      : SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final notification = vm.topNotifications[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: Card(
                            color: const Color(0xFFF4EDFC),
                            child: ListTile(
                              leading: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0xFFD9BFFF),
                                child: Icon(Icons.notifications, color: Color(0xFF6A1B9A)),
                              ),
                              title: Text(
                                utf8.decode(notification.title.codeUnits),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(utf8.decode(notification.body.codeUnits)),
                              trailing: Text(
                                formatTime(notification.createdAt),
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: vm.topNotifications.length,
                    ),
                  ),

                  SliverToBoxAdapter(child: const SizedBox(height: 16)),

                  SliverToBoxAdapter(
                    child: sectionHeader(
                      title: "Lời mời kết bạn",
                      onTap: () {},
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        var user = vm.visibleFriendRequests[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: Row(
                            children: [
                              const CircleAvatar(radius: 24, backgroundColor: Color(0xFFF4EDFC)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(user['mutual']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                child: const Text("Xác nhận"),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () {},
                                child: const Text("Xoá"),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: vm.visibleFriendRequests.length,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget sectionHeader({required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: onTap,
            child: const Text("Xem tất cả", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inMinutes < 60) return "${difference.inMinutes} phút trước";
    if (difference.inHours < 24) return "${difference.inHours} giờ trước";
    return "${difference.inDays} ngày trước";
  }
}
