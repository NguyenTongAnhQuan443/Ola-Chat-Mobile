import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:olachat_mobile/view_models/notification_view_model.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header_one.dart';

class AllNotificationsScreen extends StatelessWidget {
  const AllNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (_) => NotificationViewModel()..initPagination(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Consumer<NotificationViewModel>(
            builder: (context, vm, _) {
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 200 &&
                      !vm.isLoadingFullList &&
                      vm.hasMore) {
                    vm.fetchMoreNotifications();
                  }
                  return false;
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(child: AppLogoHeaderOne(showBackButton: true)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text("Tất cả thông báo", style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          if (index == vm.allNotifications.length) {
                            return vm.hasMore
                                ? const Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(child: CircularProgressIndicator()),
                            )
                                : const SizedBox();
                          }

                          final item = vm.allNotifications[index];
                          final isUnread = !item.read;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isUnread ? const Color(0xFFF4EDFC) : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Color(0xFFD9BFFF),
                                  child: Icon(Icons.notifications, color: Color(0xFF6A1B9A)),
                                ),
                                title: Text(
                                  utf8.decode(item.title.codeUnits),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(utf8.decode(item.body.codeUnits)),
                                trailing: Text(
                                  _formatTime(item.createdAt),
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: vm.allNotifications.length + 1,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inMinutes < 60) return "${difference.inMinutes} phút trước";
    if (difference.inHours < 24) return "${difference.inHours} giờ trước";
    return "${difference.inDays} ngày trước";
  }
}
