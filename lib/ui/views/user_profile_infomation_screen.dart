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

/// Màn hình hiển thị thông tin cá nhân và danh sách bài viết
class UserProfileInfomationScreen extends StatefulWidget {
  final UserResponseModel user;
  final List<PostModel> myPosts;

  /// Trạng thái kết bạn hiện tại (friendAction code)
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginVM = Provider.of<LoginViewModel>(context, listen: false);
      final friendVM = Provider.of<FriendRequestViewModel>(context, listen: false);

      // Lấy ID người dùng hiện tại
      final id = await loginVM.getCurrentUserId();
      setState(() => currentUserId = id);

      // Lấy danh sách lời mời đã gửi & đã nhận
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

  /// Header logo + back
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

  /// Thông tin cá nhân + avatar + nickname + bio + thông số
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
            if (currentUserId != null && widget.user.userId != currentUserId) buildFriendActionButton(widget.friendAction),
            const SizedBox(height: 16),
            const Divider(),
            buildBottomBar(),
          ],
        ),
      ),
    );
  }

  /// Box hiển thị thống kê (Post, Followers, Following)
  Widget buildStatBox(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  /// Thanh menu icon bên dưới avatar
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

  /// Nút icon trong thanh menu
  Widget buildIconButton(int index, IconData icon) {
    return IconButton(
      icon: Icon(icon, size: 20, color: selectedIndex == index ? Colors.blue : Colors.black54),
      onPressed: () => setState(() => selectedIndex = index),
    );
  }

  /// Tab hiển thị bài viết, lưu trữ, cài đặt
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

  /// Hiển thị nút hành động kết bạn dựa vào friendAction
  Widget buildFriendActionButton(int action) {
    final friendVM = Provider.of<FriendRequestViewModel>(context, listen: false);

    switch (action) {
      case 1: // Gửi lời mời kết bạn
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
          },
          icon: const Icon(Icons.person_add),
          label: const Text("Kết bạn"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4B67D3),
            foregroundColor: Colors.white,
          ),
        );

      case 3: // ACCEPT_REQUEST
        return ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Lời mời kết bạn"),
                content: const Text("Bạn muốn phản hồi lời mời kết bạn này?"),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await Provider.of<FriendRequestViewModel>(context, listen: false)
                          .acceptRequest(widget.user.userId, context);
                    },
                    child: const Text("Chấp nhận"),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await Provider.of<FriendRequestViewModel>(context, listen: false)
                          .rejectRequest(widget.user.userId, context);
                    },
                    child: const Text("Từ chối"),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.person_add_alt),
          label: const Text("Phản hồi"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        );

      case 4: // UNFRIEND
        return ElevatedButton.icon(
          onPressed: () {
            showSuccessSnackBar(context, "Hủy kết bạn (chưa làm)");
          },
          icon: const Icon(Icons.person_remove),
          label: const Text("Hủy kết bạn"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black87,
          ),
        );

      case 5: // MESSAGE
        return ElevatedButton.icon(
          onPressed: () {
            showSuccessSnackBar(context, "Chuyển sang chat (chưa làm)");
          },
          icon: const Icon(Icons.message),
          label: const Text("Nhắn tin"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        );

      case 0: // NONE (kết bạn)
      default:
        return ElevatedButton.icon(
          onPressed: () async {
            final senderId = await Provider.of<LoginViewModel>(context, listen: false).getCurrentUserId();
            if (senderId == null) {
              showErrorSnackBar(context, "Thiếu thông tin người dùng");
              return;
            }

            await Provider.of<FriendRequestViewModel>(context, listen: false).sendRequest(
              senderId: senderId,
              receiverId: widget.user.userId,
              context: context,
            );
          },
          icon: const Icon(Icons.person_add),
          label: const Text("Kết bạn"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4B67D3),
            foregroundColor: Colors.white,
          ),
        );
    }
  }
}
