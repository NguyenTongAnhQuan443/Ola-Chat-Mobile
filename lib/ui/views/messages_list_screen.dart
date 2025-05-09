import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/list_conversation_view_model.dart';
import '../widgets/custom_sliver_to_box_adapter.dart';
import '../widgets/app_logo_header_two.dart';
import 'messages_conversation_screen.dart';

class MessagesListScreen extends StatefulWidget {
  const MessagesListScreen({super.key});

  @override
  State<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen> {
  @override
  void initState() {
    super.initState();
    // Trì hoãn gọi fetchConversations sau khi build xong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ListConversationViewModel>(context, listen: false)
          .fetchConversations();
    });
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
                  AppLogoHeaderTwo(),
                  CustomSliverToBoxAdapter(),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 54,
                      color: Colors.white,
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.create_outlined,
                                size: 20, color: Colors.black54),
                            SizedBox(width: 10),
                            Text('New Message',
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
                                message.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              subtitle: Text(
                                message.lastMessage,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MessagesConversationScreen(
                                      conversationId: message.id,
                                      conversationName: message.name,
                                      avatarUrl: message.avatarUrl,
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
