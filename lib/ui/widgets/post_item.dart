import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/post_model.dart';

class PostItem extends StatelessWidget {
  final PostModel post;
  final bool showCommentButton;

  const PostItem({
    super.key,
    required this.post,
    this.showCommentButton = false,
  });

  String formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('dd/MM/yyyy HH:mm').format(dt);
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + Name + Time
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(post.user.avatarUrl),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.user.userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    Text(
                      formatDate(post.postTime),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, size: 20),
            ],
          ),

          const SizedBox(height: 10),

          // Content
          if (post.postContent.isNotEmpty)
            Text(
              post.postContent,
              style: const TextStyle(fontSize: 15),
            ),

          // Ảnh đính kèm (nếu có)
          if (post.attachments.isNotEmpty)
            _buildImageCarousel(post.attachments),

          const SizedBox(height: 12),

          // Actions: Like - Comment - Share
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAction(Icons.thumb_up_alt_outlined, 'Thích'),
              _buildAction(Icons.comment_outlined, 'Bình luận'),
              _buildAction(Icons.share_outlined, 'Chia sẻ'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(List<String> urls) {
    return Container(
      height: 220,
      margin: const EdgeInsets.only(top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: PageView.builder(
          itemCount: urls.length,
          controller: PageController(viewportFraction: 0.95),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  urls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.broken_image),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAction(IconData icon, String label) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18, color: Colors.grey[700]),
      label: Text(label, style: TextStyle(color: Colors.grey[700])),
    );
  }
}
