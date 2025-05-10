import 'package:flutter/material.dart';
import 'package:olachat_mobile/data/services/token_service.dart';
import 'package:provider/provider.dart';

import '../../core/utils/constants.dart';
import '../../view_models/group_management_view_model.dart';
import '../widgets/app_logo_header_one.dart';
import 'add_group_members_screen.dart';
import 'group_members_screen.dart';

class GroupManagementScreen extends StatefulWidget {
  final String conversationId;
  final String groupName;
  final String groupAvatar;

  const GroupManagementScreen({
    super.key,
    required this.conversationId,
    required this.groupName,
    required this.groupAvatar,
  });

  @override
  State<GroupManagementScreen> createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends State<GroupManagementScreen> {
  late String _groupName;

  @override
  void initState() {
    super.initState();
    _groupName = widget.groupName;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const AppLogoHeaderOne(showBackButton: true),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage(widget.groupAvatar),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: const Icon(Icons.camera_alt, size: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _groupName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => _showRenameGroupDialog(context),
                          child: const Icon(Icons.edit, size: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildActionRow(
                    icon: Icons.people_alt_outlined,
                    title: "Xem thành viên",
                    onTap: () async {
                      final currentUserId = await TokenService.getCurrentUserId();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GroupMembersScreen(
                            conversationId: widget.conversationId,
                            currentUserId: currentUserId ?? '', // Handle null case
                          ),
                        ),
                      );
                    },
                  ),
                  _buildActionRow(
                    icon: Icons.person_add_alt,
                    title: "Thêm thành viên",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddGroupMembersScreen(
                            groupId: widget.conversationId,
                          ),
                        ),
                      );
                    },

                  ),
                  _buildActionRow(
                    icon: Icons.photo,
                    title: "Thay đổi hình nền",
                    onTap: () {},
                  ),
                  _buildActionRow(
                    icon: Icons.link,
                    title: "Link nhóm",
                    subtitle: "https://ola.chat/g/abc123",
                    onTap: () {},
                  ),
                  const Divider(height: 32),
                  _buildActionRow(
                    icon: Icons.exit_to_app,
                    title: "Rời nhóm",
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () {},
                  ),
                  _buildActionRow(
                    icon: Icons.delete_forever,
                    title: "Giải tán nhóm",
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.black87),
      title: Text(title,
          style: TextStyle(
              fontSize: 15,
              color: textColor ?? Colors.black87,
              fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 13))
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }

  void _showRenameGroupDialog(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    final vm = Provider.of<GroupManagementViewModel>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Đặt tên nhóm",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 260, // ⬅️ thu gọn chiều rộng
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: "Nhập tên mới",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (_) =>
                        _handleSave(context, _controller.text.trim(), vm),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Huỷ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87, // không màu nền
                          ),
                        ),
                      ),
                    ),
                    Container(
                        width: 1, height: 48, color: Colors.grey.shade300),
                    Expanded(
                      child: TextButton(
                        onPressed: () =>
                            _handleSave(context, _controller.text.trim(), vm),
                        child: Text(
                          "Lưu",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppStyles.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave(
      BuildContext context, String newName, GroupManagementViewModel vm) async {
    if (newName.isEmpty) return;
    final success = await vm.updateGroup(
      groupId: widget.conversationId,
      name: newName,
    );
    if (context.mounted) {
      Navigator.pop(context);
      if (success) {
        setState(() {
          _groupName = newName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Đổi tên nhóm thành công")),
        );
      }
    }
  }

  Future<void> _updateGroupName(
      BuildContext context, String newName, GroupManagementViewModel vm) async {
    if (newName.isEmpty) return;

    final success = await vm.updateGroup(
      groupId: widget.conversationId,
      name: newName,
    );

    if (context.mounted) {
      Navigator.pop(context);
      if (success) {
        setState(() {
          _groupName = newName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Đổi tên nhóm thành công")),
        );
      }
    }
  }

  void _handleRename(BuildContext context, GroupManagementViewModel vm,
      TextEditingController controller) async {
    final newName = controller.text.trim();
    if (newName.isEmpty) return;

    final success = await vm.updateGroup(
      groupId: widget.conversationId,
      name: newName,
    );

    if (!context.mounted) return;

    Navigator.pop(context);

    if (success) {
      setState(() => _groupName = newName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Đổi tên nhóm thành công")),
      );
    }
  }
}
