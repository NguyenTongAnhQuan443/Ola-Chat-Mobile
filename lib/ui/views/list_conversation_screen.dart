import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/views/chat_screen.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../services/token_service.dart';
import '../../view_models/list_conversation_view_model.dart';
import '../widgets/custom_sliver_to_box_adapter.dart';
import '../widgets/app_logo_header_two.dart';
import 'create_group_screen.dart';
import 'messages_conversation_screen.dart';

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
    // Gọi lần đầu sau khi build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    Provider.of<ListConversationViewModel>(context, listen: false)
        .fetchConversations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context)!); // Đăng ký theo dõi route
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this); // Hủy đăng ký
    super.dispose();
  }

  // Khi quay lại màn hình này từ màn khác
  @override
  void didPopNext() {
    _fetchData(); // Load lại danh sách hội thoại
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ListConversationViewModel>(context);
    final messages = vm.conversations;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  AppLogoHeaderTwo(showMessageIcon: false),
                  CustomSliverToBoxAdapter(),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 54,
                      color: Colors.white,
                      child: TextButton(
                        onPressed: () {},
                        // onPressed: () async {
                        //   final result = await Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const CreateGroupScreen(),
                        //     ),
                        //   );
                        //
                        //   // Nếu kết quả trả về là true (tạo nhóm thành công), load lại danh sách
                        //   if (result == true && mounted) {
                        //     Provider.of<ListConversationViewModel>(context,
                        //             listen: false)
                        //         .fetchConversations();
                        //   }
                        // },
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
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage: message
                                            .avatarUrl.isNotEmpty
                                        ? NetworkImage(message.avatarUrl)
                                        : const AssetImage(
                                                'assets/images/default_avatar.png')
                                            as ImageProvider,
                                  ),
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
                              title: Text(
                                message.type == 'GROUP'
                                    ? 'Nhóm: ${message.name}'
                                    : message.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              subtitle: Text(
                                message.lastMessage?.content ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
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

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      name: message.name,
                                      avatarUrl: message.avatarUrl,
                                      isOnline: message.isOnline ?? false,
                                      userId: currentUserId,
                                      conversationId: message.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      childCount: messages.length,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
