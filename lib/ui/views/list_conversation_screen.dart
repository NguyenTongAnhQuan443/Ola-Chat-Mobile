import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/views/chat_screen.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../services/token_service.dart';
import '../../view_models/conversation_view_model.dart';
import '../../view_models/list_conversation_view_model.dart';
import '../widgets/custom_sliver_to_box_adapter.dart';
import '../widgets/app_logo_header_two.dart';
import 'create_group_screen.dart';
import 'join_live_screen.dart';

// Màn hình danh sách cuộc trò chuyện
class ListConversationScreen extends StatefulWidget {
  const ListConversationScreen({super.key});

  @override
  State<ListConversationScreen> createState() => _ListConversationScreenState();
}

class _ListConversationScreenState extends State<ListConversationScreen>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    // Gọi fetch dữ liệu sau khi build xong frame đầu tiên
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  // Gọi ViewModel để lấy danh sách cuộc trò chuyện từ API
  void _fetchData() {
    Provider.of<ListConversationViewModel>(context, listen: false)
        .fetchConversations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Đăng ký theo dõi route để biết khi nào quay lại màn hình này
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    // Hủy đăng ký khi màn hình bị dispose
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Hàm này được gọi khi quay lại màn hình từ một màn hình khác
  @override
  void didPopNext() {
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ListConversationViewModel>(context);
    final messages = vm.conversations; // Danh sách hội thoại

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  // Header logo
                  AppLogoHeaderTwo(showMessageIcon: false),
                  CustomSliverToBoxAdapter(), // Spacer

                  // Nút tạo nhóm chat (đang để trống onPressed)
                  SliverToBoxAdapter(
                    child: Container(
                      height: 54,
                      color: Colors.white,
                      child: TextButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateGroupScreen(),
                            ),
                          );

                          // Nếu kết quả trả về là true (tạo nhóm thành công), load lại danh sách
                          if (result == true && mounted) {
                            Provider.of<ListConversationViewModel>(context,
                                    listen: false)
                                .fetchConversations();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.create_outlined,
                                size: 20, color: Colors.black54),
                            SizedBox(width: 10),
                            Text('Tạo nhóm chat',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  CustomSliverToBoxAdapter(),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 54,
                      color: Colors.white,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const JoinLiveScreen()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.live_tv_outlined, size: 20, color: Colors.redAccent),
                            SizedBox(width: 10),
                            Text(
                              'Xem livestream',
                              style: TextStyle(fontSize: 14, color: Colors.redAccent),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  CustomSliverToBoxAdapter(), // Spacer

                  // Danh sách hội thoại
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final message = messages[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: InkWell(
                            child: ListTile(
                              leading: Stack(
                                children: [
                                  // Avatar người dùng hoặc nhóm
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage: message
                                            .avatarUrl.isNotEmpty
                                        ? NetworkImage(message.avatarUrl)
                                        : const AssetImage(
                                                'assets/images/default_avatar.png')
                                            as ImageProvider,
                                  ),
                                  // Chấm xanh biểu thị "online"
                                  const Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 6,
                                      backgroundColor: Colors.green,
                                    ),
                                  ),
                                ],
                              ),

                              // Hiển thị tên nhóm hoặc người dùng
                              title: Text(
                                message.type == 'GROUP'
                                    ? 'Nhóm: ${message.name}'
                                    : message.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),

                              // Tin nhắn cuối cùng trong hội thoại
                              subtitle: Text(
                                message.lastMessage?.content ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              // Khi bấm vào cuộc trò chuyện
                              onTap: () async {
                                final currentUserId =
                                    await TokenService.getCurrentUserId();

                                if (currentUserId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Không thể xác định người dùng hiện tại')),
                                  );
                                  return;
                                }

                                // Mở ChatScreen với thông tin truyền vào
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangeNotifierProvider(
                                      create: (_) => ConversationViewModel(),
                                      child: ChatScreen(
                                        name: message.name,
                                        avatarUrl: message.avatarUrl,
                                        isOnline: message.isOnline ?? false,
                                        userId: currentUserId,
                                        conversationId: message.id,
                                        conversationType: message.type,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      childCount: messages.length, // Số lượng item
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
