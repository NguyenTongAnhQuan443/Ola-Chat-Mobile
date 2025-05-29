import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      {'text': 'hi', 'isMe': false, 'time': '02:45'},
      {'text': '😀', 'isMe': true, 'time': '01:45'},
      {'image': 'assets/sticker1.png', 'isMe': false, 'time': '01:45'},
      {'image': 'assets/sticker2.png', 'isMe': true, 'time': '02:46'},
      {'text': 'alo', 'isMe': true, 'time': '08:41'},
      {'text': '1111', 'isMe': true, 'time': '08:24'},
      {'text': 'efwwfwf', 'isMe': true, 'time': '08:23'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F2FA),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.png'),
              radius: 18,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Lê Tấn Phát", style: TextStyle(color: Colors.black)),
                Text("Online",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.indigo),
            onPressed: () {
              // TODO: gọi điện
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.indigo),
            onPressed: () {
              // TODO: gọi video
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.indigo),
            onSelected: (value) {
              // TODO: xử lý các lựa chọn
              if (value == 'xoa') {
                // xoá đoạn chat
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'xoa',
                child: Text('Xoá đoạn chat'),
              ),
              const PopupMenuItem(
                value: 'chan',
                child: Text('Chặn người này'),
              ),
            ],
          ),
        ],
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
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
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (image != null)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Image.asset(image, height: 100),
                        ),
                      if (text != null)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(text),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(time,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.emoji_emotions_outlined),
                      onPressed: () {}),
                  IconButton(
                      icon: const Icon(Icons.image_outlined), onPressed: () {}),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Nhập tin nhắn...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
