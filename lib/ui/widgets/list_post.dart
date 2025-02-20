import 'package:flutter/material.dart';

import '../../data/models/post.dart';
import '../views/comments_screen.dart';

class ListPost extends StatefulWidget {
  final List<Post> posts;
  final bool showCommentButton;

  const ListPost(
      {super.key,
      required this.posts,
      required this.showCommentButton});

  @override
  _ListPostState createState() => _ListPostState();
}

class _ListPostState extends State<ListPost> {
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
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(post.user.avatarUrl),
                      onBackgroundImageError: (_, __) => Icon(Icons.error),
                    ),
                    title: Text(
                      post.user.userName,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(post.user.nickName,
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.more_horiz, size: 20),
                        Text(post.postTime,
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(post.postContent, style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 12),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Ẩn/hiện button comment dựa trên tham số showCommentButton
                      if (widget.showCommentButton)
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentsScreen()));
                          },
                          icon: Icon(Icons.mode_comment_outlined,
                              size: 20, color: Colors.grey),
                          label: Text("Comment",
                              style: TextStyle(color: Colors.grey)),
                        ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.thumb_up_alt_outlined,
                                size: 20, color: Colors.grey),
                            onPressed: () => _incrementLike(post),
                          ),
                          Text("${post.likeCount} Likes",
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.thumb_down_alt_outlined,
                                size: 20, color: Colors.grey),
                            onPressed: () => _incrementDislike(post),
                          ),
                          Text("${post.dislikeCount} Dislikes",
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(width: 10),
                        ],
                      )
                    ],
                  )
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
