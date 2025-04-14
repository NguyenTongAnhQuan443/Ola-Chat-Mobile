import 'package:flutter/material.dart';
import '../../data/models/user_response.dart';
import '../widgets/app_logo_header.dart';

class UserProfileScreen extends StatelessWidget {
  final UserResponse user;

  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: AppLogoHeader(showBackButton: true),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: user.avatar.isNotEmpty
                          ? NetworkImage(user.avatar)
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
                    Text(
                      "@${user.username}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      user.nickname.isNotEmpty ? user.nickname : '',
                      style: const TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    if (user.bio.isNotEmpty)
                      Text(
                        user.bio,
                        style: const TextStyle(color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildStatBox("12", "Posts"),
                        buildStatBox("207", "Followers"),
                        buildStatBox("64", "Following"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatBox(String count, String label) {
    return Column(
      children: [
        Text(count,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
