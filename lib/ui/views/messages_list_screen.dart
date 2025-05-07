import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:olachat_mobile/core/utils/config/api_config.dart';
import 'package:olachat_mobile/data/services/token_service.dart';
import 'package:olachat_mobile/ui/widgets/custom_sliver_to_box_adapter.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header_two.dart';
import 'messages_conversation_screen.dart';

class ConversationModel {
  final String id;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final bool isOnline;

  ConversationModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.isOnline,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Không tên',
      avatarUrl: json['avatar'] ?? '',
      lastMessage: json['lastMessage']?['content'] ?? '',
      isOnline: true, // Placeholder
    );
  }
}

class MessagesListScreen extends StatefulWidget {
  const MessagesListScreen({super.key});

  @override
  State<MessagesListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessagesListScreen> {
  List<ConversationModel> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      final token = await TokenService.getAccessToken();
      final url = Uri.parse("${ApiConfig.base}/api/conversations");

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> list = data['data'];
        setState(() {
          messages = list.map((e) => ConversationModel.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load conversations');
      }
    } catch (e) {
      print('❌ Error loading conversations: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
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
                      Icon(Icons.create_outlined, size: 20, color: Colors.black54),
                      SizedBox(width: 10),
                      Text('New Message', style: TextStyle(fontSize: 14, color: Colors.black54)),
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
                              backgroundImage: message.avatarUrl.isNotEmpty
                                  ? NetworkImage(message.avatarUrl)
                                  : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                            ),
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.green, // giả định online
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          message.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                              builder: (context) => const MessagesConversationScreen(),
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
