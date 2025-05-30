import 'package:flutter/material.dart';
import '../../../models/post_model.dart';
import 'post_item.dart';

class ListPost extends StatelessWidget {
  final List<PostModel> posts;
  final bool showCommentButton;

  const ListPost({
    super.key,
    required this.posts,
    this.showCommentButton = false,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("Chưa có bài viết nào"),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostItem(
          post: posts[index],
          showCommentButton: showCommentButton,
        );
      },
    );
  }
}
