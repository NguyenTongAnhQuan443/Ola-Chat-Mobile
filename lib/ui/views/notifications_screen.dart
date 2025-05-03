import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header_two.dart';
import 'package:olachat_mobile/view_models/notification_view_model.dart';
import 'package:olachat_mobile/view_models/friend_request_view_model.dart';
import '../../data/services/token_service.dart';
import 'all_friend_requests_screen.dart';
import 'all_notifications_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final vm = NotificationViewModel();
            TokenService.getAccessToken().then((token) {
              if (token != null) vm.fetchFriendRequests(token);
            });
            vm.fetchTopNotifications();
            return vm;
          },
        ),
        ChangeNotifierProvider(create: (_) => FriendRequestViewModel()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer2<NotificationViewModel, FriendRequestViewModel>(
          builder: (context, vm, friendVM, _) {
            return RefreshIndicator(
              onRefresh: vm.fetchTopNotifications,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  AppLogoHeaderTwo(),
                  SliverToBoxAdapter(
                      child:
                          Container(height: 10, color: Colors.grey.shade100)),
                  SliverToBoxAdapter(
                    child: sectionHeader(
                      title: "Thông báo mới",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AllNotificationsScreen()),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                child: Card(
                                  color: const Color(0xFFF4EDFC),
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Color(0xFFD9BFFF),
                                      child: Icon(Icons.notifications,
                                          color: Color(0xFF6A1B9A)),
                                    ),
                                    title: Text(
                                      utf8.decode(notification.title.codeUnits),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(utf8
                                        .decode(notification.body.codeUnits)),
                                    trailing: Text(
                                      formatTime(notification.createdAt),
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AllFriendRequestsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  vm.visibleFriendRequests.isEmpty
                      ? const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            child: Text("Không có lời mời kết bạn nào",
                                style: TextStyle(color: Colors.grey)),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              var user = vm.visibleFriendRequests[index];
                              final userId = user['userId']!;
                              final isAccepting =
                                  vm.isButtonLoading(userId, "accept");
                              final isRejecting =
                                  vm.isButtonLoading(userId, "reject");
                              final isAnyLoading = isAccepting || isRejecting;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage: user['avatar'] != null
                                          ? NetworkImage(user['avatar']!)
                                          : const AssetImage(
                                                  'assets/images/default_avatar.png')
                                              as ImageProvider,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user['name'] ?? 'Ẩn danh',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          const Text(
                                            "Đang chờ kết bạn",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: isAnyLoading
                                              ? null
                                              : () async {
                                                  vm.setButtonLoading(
                                                      userId, "accept");
                                                  await friendVM
                                                      .fetchReceivedRequests();
                                                  await friendVM.acceptRequest(
                                                      userId, context);
                                                  final token =
                                                      await TokenService
                                                          .getAccessToken();
                                                  if (token != null) {
                                                    await vm
                                                        .fetchFriendRequests(
                                                            token);
                                                  }
                                                  vm.setButtonLoading(
                                                      userId, null);
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF4B67D3),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            textStyle:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          child: isAccepting
                                              ? const SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.white),
                                                )
                                              : const Text("Chấp nhận"),
                                        ),
                                        const SizedBox(width: 8),
                                        OutlinedButton(
                                          onPressed: isAnyLoading
                                              ? null
                                              : () async {
                                                  vm.setButtonLoading(
                                                      userId, "reject");
                                                  await friendVM
                                                      .fetchReceivedRequests();
                                                  await friendVM.rejectRequest(
                                                      userId, context);
                                                  final token =
                                                      await TokenService
                                                          .getAccessToken();
                                                  if (token != null) {
                                                    await vm
                                                        .fetchFriendRequests(
                                                            token);
                                                  }
                                                  vm.setButtonLoading(
                                                      userId, null);
                                                },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor:
                                                const Color(0xFF4B67D3),
                                            side: const BorderSide(
                                                color: Color(0xFF4B67D3)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            textStyle:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          child: isRejecting
                                              ? const SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 2),
                                                )
                                              : const Text("Từ chối"),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                            childCount: vm.visibleFriendRequests.length,
                          ),
                        )
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
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: onTap,
            child:
                const Text("Xem tất cả", style: TextStyle(color: Colors.black)),
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
