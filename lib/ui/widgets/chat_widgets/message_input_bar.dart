import 'package:flutter/material.dart';

// Widget thanh nhập tin nhắn ở cuối màn hình trò chuyện
class MessageInputBar extends StatelessWidget {
  const MessageInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: SafeArea(
        child: Row(
          children: [
            // Nút mở emoji (chưa xử lý logic)
            IconButton(
              icon: const Icon(Icons.emoji_emotions_outlined),
              onPressed: () {},
            ),

            // Nút mở gallery hoặc gửi ảnh (chưa xử lý)
            IconButton(
              icon: const Icon(Icons.image_outlined),
              onPressed: () {},
            ),

            // Nút ghi âm (chưa xử lý)
            IconButton(
              icon: const Icon(Icons.mic, color: Colors.deepPurple),
              onPressed: () {},
            ),

            // Ô nhập văn bản
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

            // Nút gửi tin nhắn (chưa xử lý logic gửi)
            IconButton(
              icon: const Icon(Icons.send, color: Colors.deepPurple),
              onPressed: () {}, // TODO: cần truyền hàm gửi tin nhắn
            ),
          ],
        ),
      ),
    );
  }
}
