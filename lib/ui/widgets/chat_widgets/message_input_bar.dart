import 'package:flutter/material.dart';

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
            IconButton(icon: const Icon(Icons.emoji_emotions_outlined), onPressed: () {}),
            IconButton(icon: const Icon(Icons.image_outlined), onPressed: () {}),
            IconButton(icon: const Icon(Icons.mic, color: Colors.deepPurple), onPressed: () {}),
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
            IconButton(icon: const Icon(Icons.send, color: Colors.deepPurple), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
