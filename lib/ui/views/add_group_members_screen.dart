import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/constants.dart';
import '../../view_models/add_group_members_view_model.dart';
import '../widgets/app_logo_header_one.dart';

class AddGroupMembersScreen extends StatefulWidget {
  final String groupId;

  const AddGroupMembersScreen({super.key, required this.groupId});

  @override
  State<AddGroupMembersScreen> createState() => _AddGroupMembersScreenState();
}

class _AddGroupMembersScreenState extends State<AddGroupMembersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<AddGroupMembersViewModel>(context, listen: false).fetchFriends();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddGroupMembersViewModel>(context);
    final filteredFriends = vm.friends.where((f) {
      final query = _searchController.text.toLowerCase().trim();
      return f.displayName.toLowerCase().contains(query);
    }).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const AppLogoHeaderOne(showBackButton: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Thêm thành viên vào nhóm",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm bạn bè...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filteredFriends.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final friend = filteredFriends[index];
                  final isSelected = vm.selectedUserIds.contains(friend.userId);

                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: vm.isSubmitting ? null : (_) {
                      vm.toggleUserSelection(friend.userId);
                    },
                    title: Text(friend.displayName),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppStyles.primaryColor,
                    secondary: CircleAvatar(
                      radius: 20,
                      backgroundImage: friend.avatar.isNotEmpty
                          ? NetworkImage(friend.avatar)
                          : null,
                      backgroundColor: friend.avatar.isEmpty
                          ? AppStyles.primaryColor
                          : Colors.transparent,
                      child: friend.avatar.isEmpty
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: vm.isSubmitting
                      ? null
                      : () async {
                    final success = await vm.addMembersToGroup(widget.groupId);
                    if (success && context.mounted) {
                      Navigator.pop(context, true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ Đã thêm thành viên vào nhóm")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("❌ Thêm thành viên thất bại")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: vm.isSubmitting
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text("Thêm thành viên", style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
