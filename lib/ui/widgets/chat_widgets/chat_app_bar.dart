import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:provider/provider.dart';

import '../../../view_models/add_group_members_view_model.dart';
import '../../../view_models/conversation_view_model.dart';
import '../../views/add_group_members_screen.dart';
import '../../views/zego_call_screen.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final String conversationId;
  final String currentUserId;
  final String currentUserName;
  final String conversationType;

  const ChatAppBar({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.isOnline,
    required this.conversationId,
    required this.currentUserId,
    required this.currentUserName,
    required this.conversationType,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF5F2FA),
      automaticallyImplyLeading: false, // Không hiển thị nút mặc định (back)

      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context), // Quay lại màn hình trước
      ),

      // Phần chính hiển thị avatar + tên + trạng thái online
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
            radius: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dòng tên hiển thị theo dạng chạy marquee nếu dài
                SizedBox(
                  height: 20,
                  width: double.infinity,
                  child: Marquee(
                    text: name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    scrollAxis: Axis.horizontal,
                    blankSpace: 30.0,
                    velocity: 30.0,
                    pauseAfterRound: const Duration(seconds: 1),
                    startPadding: 0.0,
                    accelerationDuration: const Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: const Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  ),
                ),
                // Dòng hiển thị trạng thái online / offline
                Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: isOnline ? Colors.green : Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      isOnline ? "Online" : "Offline",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      // Các nút hành động ở bên phải AppBar: Gọi thoại, gọi video, và menu 3 chấm
      actions: [
        // Nút gọi thoại
        IconButton(
          icon: const Icon(Icons.call, color: Colors.indigo),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ZegoCallScreen(
                  userId: currentUserId,
                  userName: currentUserName,
                  callID: conversationId,
                  isVideoCall: false, // Gọi thoại
                ),
              ),
            );
          },
        ),

        // Nút gọi video
        IconButton(
          icon: const Icon(Icons.videocam, color: Colors.indigo),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ZegoCallScreen(
                  userId: currentUserId,
                  userName: currentUserName,
                  callID: conversationId,
                  isVideoCall: true, // Gọi video
                ),
              ),
            );
          },
        ),

        // Nút mở menu 3 chấm (popup menu)
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.indigo),
          onSelected: (value) async {
            if (value == 'xoa') {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Xác nhận xoá"),
                  content: const Text("Bạn có chắc muốn xoá đoạn chat này?"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Hủy")),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Xoá", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                final result =
                    await Provider.of<ConversationViewModel>(context, listen: false).deleteConversation(conversationId);

                if (result && context.mounted) {
                  Navigator.pop(context); // Thoát khỏi màn hình chat
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("${AppStyles.successIcon}Đã xoá cuộc trò chuyện")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("${AppStyles.failureIcon} Xoá thất bại")),
                  );
                }
              }
            } else if (value == 'group_setting') {
              // ✅ Không tạo lại Provider ở đây nữa vì đã tạo ở main.dart
              Future.microtask(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddGroupMembersScreen(groupId: conversationId),
                  ),
                );
              });
            } else if (value == 'private_setting') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("⚙️ Tính năng đang phát triển...")),
              );
            }
          },
          itemBuilder: (context) {
            if (conversationType == 'GROUP') {
              return const [
                PopupMenuItem(value: 'xoa', child: Text('Xoá đoạn chat')),
                PopupMenuItem(value: 'group_setting', child: Text('Thiết lập nhóm')),
              ];
            } else {
              return const [
                PopupMenuItem(value: 'xoa', child: Text('Xoá đoạn chat')),
                PopupMenuItem(value: 'private_setting', child: Text('Thiết lập')),
              ];
            }
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60); // Chiều cao AppBar
}
