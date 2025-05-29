import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String avatarUrl;
  final bool isOnline;
  const ChatAppBar({super.key, required this.name, required this.avatarUrl, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF5F2FA),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : const AssetImage('assets/images/default_avatar.png')
            as ImageProvider,
            radius: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
      actions: [
        const IconButton(icon: Icon(Icons.call, color: Colors.indigo), onPressed: null),
        const IconButton(icon: Icon(Icons.videocam, color: Colors.indigo), onPressed: null),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.indigo),
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'xoa', child: Text('Xoá đoạn chat')),
            PopupMenuItem(value: 'chan', child: Text('Chặn người này')),
          ],
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
