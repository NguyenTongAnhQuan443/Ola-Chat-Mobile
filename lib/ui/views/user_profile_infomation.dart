import 'package:flutter/material.dart';
import 'package:olachat_mobile/core/utils/constants.dart';
import 'package:olachat_mobile/data/models/post_model.dart';
import 'package:olachat_mobile/ui/views/user_settings_screen.dart';
import 'package:provider/provider.dart';

import '../../data/models/user_response_model.dart';
import '../../view_models/friend_request_view_model.dart';
import '../../view_models/login_view_model.dart';
import '../widgets/custom_sliver_to_box_adapter.dart';
import '../widgets/list_post.dart';
import '../widgets/show_snack_bar.dart';

class UserProfileInfomationScreen extends StatefulWidget {
  final UserResponseModel user;
  final List<PostModel> myPosts;

  const UserProfileInfomationScreen(
      {super.key, required this.user, this.myPosts = const []});

  @override
  State<UserProfileInfomationScreen> createState() =>
      _UserProfileInfoScreenState();
}

class _UserProfileInfoScreenState extends State<UserProfileInfomationScreen> {
  int selectedIndex = 0;
  List<PostModel> savePosts = [];
  String? currentUserId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginVM = Provider.of<LoginViewModel>(context, listen: false);
      final friendVM =
          Provider.of<FriendRequestViewModel>(context, listen: false);

      final id = await loginVM.getCurrentUserId();
      setState(() {
        currentUserId = id;
      });

      // Đồng bộ danh sách lời mời kết bạn đã gửi với DB
      await friendVM.fetchSentRequests();
      // Đồng bộ lời mời kết bạn đã nhận
      await friendVM.fetchReceivedRequests();

    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icons/LogoApp.png',
                          width: 28,
                          height: 28,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          AppStyles.nameApp,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: (user.avatar != null &&
                              user.avatar!.isNotEmpty)
                          ? NetworkImage(user.avatar!)
                          : const AssetImage("assets/images/default_avatar.png")
                              as ImageProvider,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.displayName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    // Text(
                    //   "${user.username}",
                    //   style: const TextStyle(color: Colors.grey),
                    // ),
                    const SizedBox(height: 6),
                    if (user.nickname?.isNotEmpty == true)
                      Text(
                        user.nickname!,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    const SizedBox(height: 8),
                    if (user.bio?.isNotEmpty == true)
                      Text(
                        user.bio!,
                        style: const TextStyle(color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildStatBox("12", "Posts"),
                        buildStatBox("207", "Followers"),
                        buildStatBox("64", "Following"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (currentUserId != null &&
                        widget.user.userId != currentUserId)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer2<FriendRequestViewModel, LoginViewModel>(
                            builder: (context, friendVM, loginVM, _) {
                              final isSent = friendVM.isRequestSent(widget.user.userId);
                              final isReceived = friendVM.isReceivedRequestFrom(widget.user.userId);

                              if (isReceived) {
                                return ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Lời mời kết bạn"),
                                        content: const Text("Bạn muốn phản hồi lời mời kết bạn này?"),
                                        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        actions: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  icon: const Icon(Icons.check_circle, color: Colors.white),
                                                  label: const Text("Chấp nhận"),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xFF4B67D3),
                                                    foregroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    await friendVM.acceptRequest(widget.user.userId, context);
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: OutlinedButton.icon(
                                                  icon: const Icon(Icons.cancel, color: Colors.red),
                                                  label: const Text("Từ chối"),
                                                  style: OutlinedButton.styleFrom(
                                                    foregroundColor: Colors.red,
                                                    side: const BorderSide(color: Colors.red),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    await friendVM.rejectRequest(widget.user.userId, context);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.person_add_alt, color: Colors.white),
                                  label: const Text("Phản hồi"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4B67D3),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                );
                              }
                              return ElevatedButton.icon(
                                onPressed: friendVM.isLoading
                                    ? null
                                    : () async {
                                  final senderId = await loginVM.getCurrentUserId();
                                  final receiverId = widget.user.userId;

                                  if (senderId == null || receiverId == null) {
                                    showErrorSnackBar(context, "Thiếu thông tin người dùng");
                                    return;
                                  }

                                  if (isSent) {
                                    await friendVM.cancelRequest(receiverId: receiverId, context: context);
                                  } else {
                                    await friendVM.sendRequest(
                                      senderId: senderId,
                                      receiverId: receiverId,
                                      context: context,
                                    );
                                  }
                                },
                                icon: friendVM.isLoading
                                    ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                                    : Icon(
                                  isSent ? Icons.cancel : Icons.person_add_alt,
                                  color: Colors.white,
                                ),
                                label: Text(isSent ? "Hủy lời mời" : "Kết bạn"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSent ? Colors.red : const Color(0xFF4B67D3),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              );

                            },
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.chat_bubble_outline),
                            label: const Text("Nhắn tin"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildIconButton(
                            0, Icons.grid_view_outlined, selectedIndex,
                            (index) {
                          setState(() => selectedIndex = index);
                        }),
                        buildIconButton(1, Icons.bookmark_border, selectedIndex,
                            (index) {
                          setState(() => selectedIndex = index);
                        }),
                        buildIconButton(2, Icons.settings, selectedIndex,
                            (index) {
                          setState(() => selectedIndex = index);
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            CustomSliverToBoxAdapter(),
            buildView_3(selectedIndex, widget.myPosts, savePosts),
          ],
        ),
      ),
    );
  }

  Widget buildStatBox(String count, String label) {
    return Column(
      children: [
        Text(count,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget buildIconButton(
      int index, IconData icon, int selectedIndex, Function(int) onTap) {
    return IconButton(
      icon: Icon(icon,
          size: 20,
          color: selectedIndex == index ? Colors.blue : Colors.black54),
      onPressed: () => onTap(index),
    );
  }

  Widget buildView_3(
      int selectedIndex, List<PostModel> myPosts, List<PostModel> savePosts) {
    switch (selectedIndex) {
      case 0:
        return ListPost(posts: myPosts, showCommentButton: true);
      case 1:
        return ListPost(posts: savePosts, showCommentButton: true);
      case 2:
        return const SliverToBoxAdapter(child: UserSettingScreen());
      default:
        return const SizedBox.shrink();
    }
  }
}
