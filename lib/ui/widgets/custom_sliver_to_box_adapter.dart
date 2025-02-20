import 'package:flutter/material.dart';

class CustomSliverToBoxAdapter extends StatelessWidget {
  const CustomSliverToBoxAdapter({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 10,
        color: Colors.grey.shade100,
        child: const SizedBox(height: 10),
      ),
    );
  }
}
