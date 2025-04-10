import 'package:flutter/material.dart';

import '../../data/models/post.dart';
import '../views/comments_screen.dart';
class ListPost extends StatefulWidget {
  final List<Post> posts;
  final bool showCommentButton;

  const ListPost({
    super.key,
    required this.posts,
    required this.showCommentButton,
  });

  @override
  ListPostState createState() => ListPostState();
}

class ListPostState extends State<ListPost> {
  void _incrementLike(Post post) {
    setState(() {
      post.likeCount++;
    });
  }

  void _incrementDislike(Post post) {
    setState(() {
      post.dislikeCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final post = widget.posts[index];

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(post.user.avatarUrl),
                      onBackgroundImageError: (_, __) => const Icon(Icons.error),
                    ),
                    title: Text(
                      post.user.userName,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(post.user.nickName,
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(Icons.more_horiz, size: 20),
                        Text(post.postTime,
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(post.postContent, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 12),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.showCommentButton)
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentsScreen()));
                          },
                          icon: const Icon(Icons.mode_comment_outlined,
                              size: 20, color: Colors.grey),
                          label: const Text("Comment",
                              style: TextStyle(color: Colors.grey)),
                        ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.thumb_up_alt_outlined,
                                size: 20, color: Colors.grey),
                            onPressed: () => _incrementLike(post),
                          ),
                          Text("${post.likeCount} Likes",
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.thumb_down_alt_outlined,
                                size: 20, color: Colors.grey),
                            onPressed: () => _incrementDislike(post),
                          ),
                          Text("${post.dislikeCount} Dislikes",
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        childCount: widget.posts.length,
      ),
    );
  }
}
