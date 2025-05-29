import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final String userId;

  const ChatScreen({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.isOnline,
    required this.userId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages(); // Gọi API để load tin nhắn khi mở màn hình
  }

  Future<void> _loadMessages() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Giả lập delay API
    setState(() {
      messages = [
        {'text': 'hi', 'isMe': false, 'time': '02:45'},
        {'text': '😀', 'isMe': true, 'time': '01:45'},
        {'image': 'assets/sticker1.png', 'isMe': false, 'time': '01:45'},
        {'text': 'alo', 'isMe': true, 'time': '08:41'},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea( // 🔒 Bọc toàn bộ UI trong SafeArea để tránh tràn notch, tai thỏ
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: const Color(0xFFF5F2FA),
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context), // Nút quay lại
            ),
            title: Row(
              children: [
                // 🧑 Avatar người đối thoại
                CircleAvatar(
                  backgroundImage: widget.avatarUrl.isNotEmpty
                      ? NetworkImage(widget.avatarUrl)
                      : const AssetImage('assets/images/default_avatar.png')
                  as ImageProvider,
                  radius: 18,
                ),
                const SizedBox(width: 10),

                // 👤 Tên và trạng thái Online/Offline
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 📝 Tên người dùng (scroll ngang nếu quá dài)
                      SizedBox(
                        height: 20,
                        width: double.infinity,
                        child: Marquee(
                          text: widget.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
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

                      // 🔵 Trạng thái online/offline + chấm màu
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 10,
                            color: widget.isOnline ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.isOnline ? "Online" : "Offline",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.call, color: Colors.indigo),
                onPressed: () {}, // 📞 Gọi thoại
              ),
              IconButton(
                icon: const Icon(Icons.videocam, color: Colors.indigo),
                onPressed: () {}, // 🎥 Gọi video
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.indigo),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'xoa', child: Text('Xoá đoạn chat')),
                  PopupMenuItem(value: 'chan', child: Text('Chặn người này')),
                ],
                onSelected: (value) {}, // Tuỳ chọn thêm
              ),
            ],
          ),
        ),

        // 📨 Phần nội dung chính: Danh sách tin nhắn và khung nhập
        body: Column(
          children: [
            // 📜 Danh sách tin nhắn
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[messages.length - 1 - index];
                  final isMe = msg['isMe'] as bool;
                  final text = msg['text'] as String?;
                  final image = msg['image'] as String?;
                  final time = msg['time'] as String;

                  return Align(
                    alignment:
                    isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue[50] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (image != null)
                            Image.asset(image, height: 100), // 🖼️ Gửi sticker
                          if (text != null)
                            Text(
                              text,
                              style: const TextStyle(fontSize: 15),
                            ), // 📝 Gửi text
                          const SizedBox(height: 4),
                          Text(
                            time,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                          ), // ⏰ Thời gian gửi
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 1),

            // ⌨️ Thanh nhập tin nhắn
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: SafeArea( // Bọc SafeArea để không bị dính bàn phím, notch
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions_outlined),
                      onPressed: () {}, // 😄 Gửi emoji
                    ),
                    IconButton(
                      icon: const Icon(Icons.image_outlined),
                      onPressed: () {}, // 🖼️ Gửi ảnh
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic, color: Colors.deepPurple),
                      onPressed: () {}, // 🎤 Ghi âm voice
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Nhập tin nhắn...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.deepPurple),
                      onPressed: () {}, // 📤 Gửi tin nhắn
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
