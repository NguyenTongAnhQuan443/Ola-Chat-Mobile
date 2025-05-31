import 'package:flutter/material.dart';

class LiveStreamScreen extends StatelessWidget {
  const LiveStreamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🔴 Đang Livestream")),
      body: const Center(
        child: Text(
          "Đây là màn hình livestream",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
