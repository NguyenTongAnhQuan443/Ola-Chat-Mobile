import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/constants.dart';
import '../../view_models/group_members_role_view_model.dart';
import '../../data/models/group_member_model.dart';
import '../widgets/app_logo_header_one.dart';

class GroupMembersScreen extends StatefulWidget {
  final String conversationId;
  final String currentUserId;

  const GroupMembersScreen({
    super.key,
    required this.conversationId,
    required this.currentUserId,
  });

  @override
  State<GroupMembersScreen> createState() => _GroupMembersScreenState();
}

class _GroupMembersScreenState extends State<GroupMembersScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<GroupMembersRoleViewModel>(context, listen: false)
        .fetchGroupMembers(widget.conversationId);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GroupMembersRoleViewModel>(context);
    final members = vm.members;

    // Lấy role của current user
    final currentUserRole = members
        .firstWhere(
          (e) => e.userId == widget.currentUserId,
      orElse: () => GroupMemberModel(
          userId: '', displayName: '', avatar: null, role: 'MEMBER', status: ''),
    )
        .role;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const AppLogoHeaderOne(showBackButton: true),
            const SizedBox(height: 8),
            const Text("Thành viên trong nhóm",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: members.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final member = members[index];
                  final isAdmin = member.role == "ADMIN";
                  final isModerator = member.role == "MODERATOR";
                  final isOnline = member.status == "ONLINE";

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: member.avatar != null
                          ? NetworkImage(member.avatar!)
                          : null,
                      child: member.avatar == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                      backgroundColor: member.avatar == null
                          ? AppStyles.primaryColor
                          : Colors.transparent,
                    ),
                    title: Text(
                      member.displayName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      isAdmin
                          ? "Trưởng nhóm"
                          : isModerator
                          ? "Phó nhóm"
                          : "Thành viên",
                      style: TextStyle(
                          fontSize: 13,
                          color: isAdmin
                              ? Colors.red
                              : isModerator
                              ? Colors.deepPurple
                              : Colors.grey),
                    ),
                    trailing: (currentUserRole == "ADMIN" &&
                        member.userId != widget.currentUserId)
                        ? PopupMenuButton<String>(
                      onSelected: (value) {
                        // TODO: xử lý theo action
                        if (value == 'kick') {
                          // Xoá thành viên
                        } else if (value == 'mod') {
                          // Phân quyền làm nhóm phó
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'kick',
                          child: Text("Xoá khỏi nhóm"),
                        ),
                        const PopupMenuItem(
                          value: 'mod',
                          child: Text("Phân làm phó nhóm"),
                        ),
                      ],
                    )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
