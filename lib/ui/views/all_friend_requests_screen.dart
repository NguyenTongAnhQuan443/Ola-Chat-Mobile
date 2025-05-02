import 'package:flutter/material.dart';

class AllFriendRequestsScreen extends StatelessWidget {
  final List<Map<String, String>> requests;

  const AllFriendRequestsScreen({super.key, required this.requests});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tất cả lời mời kết bạn")),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final user = requests[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                const CircleAvatar(radius: 24),
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
      ),
    );
  }
}