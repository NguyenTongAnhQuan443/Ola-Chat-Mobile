import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/widgets/custom_sliver_to_box_adapter.dart';
import 'package:olachat_mobile/ui/widgets/list_post.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header_two.dart';
import 'package:provider/provider.dart';
import '../../services/token_service.dart';
import '../../view_models/feed_view_model.dart';
import 'LiveStreamHostPage.dart';
import 'LiveStreamScreen.dart';
import 'form_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadAvatar();

    // Gọi fetchPosts() sau khi widget đã build xong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FeedViewModel>(context, listen: false).fetchPosts();
    });
  }

  Future<void> _loadAvatar() async {
    final avatar = await TokenService.getCurrentUserAvatar();
    setState(() {
      _avatarUrl = avatar;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FeedViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => vm.fetchPosts(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            AppLogoHeaderTwo(),
            CustomSliverToBoxAdapter(),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    child: _buildPostInputBar(),
                  ),
                  // Button Live Stream
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LiveStreamHostPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        icon: const Icon(Icons.live_tv),
                        label: const Text("Live"),
                      ),

                    ),
                  ),
                ],
              ),
            ),

            CustomSliverToBoxAdapter(),
            SliverToBoxAdapter(
              child: vm.isLoading
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              )
                  : ListPost(posts: vm.posts, showCommentButton: true),
            ),
          ],
        ),
      ),
    );
  }

  // Đặt lại đúng trong _FeedScreenState
  Widget _buildPostInputBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FormPostScreen()),
        );
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: _avatarUrl != null
                ? NetworkImage(_avatarUrl!)
                : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Bạn đang nghĩ gì, chia sẻ ngay?",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
