// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:olachat_mobile/models/post_model.dart';
import 'package:olachat_mobile/models/user_response_model.dart';
import 'package:olachat_mobile/ui/views/user_settings_screen.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:provider/provider.dart';
import '../../view_models/friend_request_view_model.dart';
import '../../view_models/login_view_model.dart';
import '../widgets/custom_sliver_to_box_adapter.dart';
import '../widgets/list_post.dart';
import '../widgets/show_snack_bar.dart';

class UserProfileInfomationScreen extends StatefulWidget {
  final UserResponseModel user;
  final List<PostModel> myPosts;
  final int friendAction;

  const UserProfileInfomationScreen({
    super.key,
    required this.user,
    this.myPosts = const [],
    required this.friendAction,
  });

  @override
  State<UserProfileInfomationScreen> createState() => _UserProfileInfoScreenState();
}

class _UserProfileInfoScreenState extends State<UserProfileInfomationScreen> {
  int selectedIndex = 0;
  List<PostModel> savePosts = [];
  String? currentUserId;
  int? currentFriendAction;

  @override
  void initState() {
    super.initState();
    currentFriendAction = widget.friendAction;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginVM = Provider.of<LoginViewModel>(context, listen: false);
      final friendVM = Provider.of<FriendRequestViewModel>(context, listen: false);

      final id = await loginVM.getCurrentUserId();
      setState(() => currentUserId = id);

      await friendVM.fetchSentRequests();
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
            buildHeader(),
            buildProfileInfo(user),
            CustomSliverToBoxAdapter(),
            buildView_3(selectedIndex, widget.myPosts, savePosts),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
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
              children: [
                Image.asset('assets/icons/LogoApp.png', width: 28, height: 28),
                const SizedBox(width: 10),
                const Text(AppStyles.nameApp, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileInfo(UserResponseModel user) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: (user.avatar.isNotEmpty)
                  ? NetworkImage(user.avatar)
                  : const AssetImage("assets/images/default_avatar.png") as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text(user.displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            if (user.nickname?.isNotEmpty == true) Text(user.nickname!, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 8),
            if (user.bio?.isNotEmpty == true)
              Text(user.bio!, style: const TextStyle(color: Colors.black54), textAlign: TextAlign.center),
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
            if (currentUserId != null && widget.user.userId != currentUserId)
              buildFriendActionButton(currentFriendAction ?? widget.friendAction),
            const SizedBox(height: 16),
            const Divider(),
            buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget buildStatBox(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget buildBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildIconButton(0, Icons.grid_view_outlined),
        buildIconButton(1, Icons.bookmark_border),
        buildIconButton(2, Icons.settings),
      ],
    );
  }

  Widget buildIconButton(int index, IconData icon) {
    return IconButton(
      icon: Icon(icon, size: 20, color: selectedIndex == index ? Colors.blue : Colors.black54),
      onPressed: () => setState(() => selectedIndex = index),
    );
  }

  Widget buildView_3(int selectedIndex, List<PostModel> myPosts, List<PostModel> savePosts) {
    switch (selectedIndex) {
      case 0:
      // return ListPost(posts: myPosts, showCommentButton: true);
      case 1:
      // return ListPost(posts: savePosts, showCommentButton: true);
      case 2:
        return const SliverToBoxAdapter(child: UserSettingScreen());
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildFriendActionButton(int actionCode) {
    final friendVM = Provider.of<FriendRequestViewModel>(context, listen: false);

    switch (actionCode) {
      case 1:
        // Chưa gửi -> Gửi lời mời
        return ElevatedButton.icon(
          onPressed: () async {
            final senderId = await Provider.of<LoginViewModel>(context, listen: false).getCurrentUserId();
            if (senderId == null) {
              showErrorSnackBar(context, "Thiếu thông tin người dùng");
              return;
            }
            await friendVM.sendRequest(
              senderId: senderId,
              receiverId: widget.user.userId,
              context: context,
            );
            setState(() => currentFriendAction = 2);
          },
          icon: const Icon(Icons.person_add),
          label: const Text("Kết bạn"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4B67D3),
            foregroundColor: Colors.white,
          ),
        );

      case 2:
        // Đã gửi -> Huỷ lời mời
        return ElevatedButton.icon(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Thu hồi lời mời kết bạn"),
                content: const Text("Bạn có chắc muốn thu hồi lời mời kết bạn?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Hủy"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Thu hồi", style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              await friendVM.cancelRequest(
                receiverId: widget.user.userId,
                context: context,
              );
              setState(() => currentFriendAction = 1);
            }
          },
          icon: const Icon(Icons.person_remove),
          label: const Text("Thu hồi lời mời"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black87,
          ),
        );

      case 3:
        // Nhận lời mời -> Chấp nhận / Từ chối
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Chấp nhận lời mời kết bạn"),
                    content: const Text("Bạn có chắc muốn chấp nhận lời mời kết bạn này không?"),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Hủy")),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Chấp nhận")),
                    ],
                  ),
                );

                if (confirm == true) {
                  await friendVM.acceptRequest(widget.user.userId, context);
                  setState(() => currentFriendAction = 4); // ✅ trở thành bạn bè
                }
              },
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text("Chấp nhận"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B67D3),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Từ chối lời mời kết bạn"),
                    content: const Text("Bạn có chắc muốn từ chối lời mời kết bạn này không?"),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Hủy")),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Từ chối")),
                    ],
                  ),
                );

                if (confirm == true) {
                  await friendVM.rejectRequest(widget.user.userId, context);
                  setState(() => currentFriendAction = 1); // ✅ quay lại trạng thái chưa kết bạn
                }
              },
              icon: const Icon(Icons.person_off),
              label: const Text("Từ chối"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black87,
              ),
            ),
          ],
        );

      case 4:
        // Đã là bạn bè -> Huỷ kết bạn
        return ElevatedButton.icon(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Huỷ kết bạn"),
                content: const Text("Bạn có chắc muốn huỷ kết bạn với người này không?"),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Hủy")),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Huỷ kết bạn", style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              // TODO: Gọi API huỷ kết bạn (chưa có trong ViewModel hiện tại)
              showSuccessSnackBar(context, "Đã huỷ kết bạn");
              setState(() => currentFriendAction = 1); // trở lại trạng thái chưa kết bạn
            }
          },
          icon: const Icon(Icons.person_off),
          label: const Text("Huỷ kết bạn"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black87,
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
