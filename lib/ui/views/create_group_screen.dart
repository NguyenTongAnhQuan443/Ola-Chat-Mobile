import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olachat_mobile/services/file_upload_service.dart';
import 'package:olachat_mobile/services/token_service.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../view_models/create_group_view_model.dart';
import '../widgets/app_logo_header_one.dart';
import '../widgets/show_snack_bar.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _avatarUrl = '';
  File? _selectedImage;
  bool _isUploading = false;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CreateGroupViewModel>(context, listen: false).fetchFriends();
    });
  }

  // Future<void> _pickImage() async {
  //   if (_isUploading || _isCreating) return;
  //
  //   final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     setState(() {
  //       _isUploading = true;
  //       _selectedImage = File(picked.path);
  //     });
  //
  //     final token = await TokenService.getAccessToken();
  //     final platformFile = PlatformFile(
  //       name: picked.name,
  //       path: picked.path,
  //       size: await picked.length(),
  //     );
  //
  //     final urls = await FileUploadService.([platformFile], token!);
  //     if (urls.isNotEmpty) {
  //       setState(() => _avatarUrl = urls.first);
  //     }
  //
  //     setState(() => _isUploading = false);
  //   }
  // }

  Future<void> _createGroup() async {
    final name = _nameController.text.trim();

    // ✅ CHỈ CHECK name và loading
    if (name.isEmpty || _isCreating || _isUploading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Vui lòng nhập tên nhóm')),
      );
      return;
    }

    setState(() => _isCreating = true);

    final vm = Provider.of<CreateGroupViewModel>(context, listen: false);

    // ✅ avatarUrl không còn bắt buộc
    final success = await vm.createGroup(name: name, avatarUrl: '');

    if (mounted) {
      setState(() => _isCreating = false);
      if (success) {
        showSuccessSnackBar(context, "🎉 Tạo nhóm thành công!");
        Future.delayed(const Duration(milliseconds: 400), () {
          Navigator.pop(context, true);
        });
      } else {
        showErrorSnackBar(context, "Tạo nhóm thất bại");
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CreateGroupViewModel>(context);
    final filteredFriends = vm.friends.where((friend) {
      final query = _searchController.text.trim().toLowerCase();
      return friend.displayName.toLowerCase().contains(query);
    }).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const AppLogoHeaderOne(showBackButton: true),
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Tạo nhóm chat",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Tên nhóm',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        // ElevatedButton.icon(
                        //   onPressed: _isUploading || _isCreating ? null : _pickImage,
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.white,
                        //     foregroundColor: AppStyles.primaryColor,
                        //     elevation: 0,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10), // ít bo góc
                        //     ),
                        //   ),
                        //   icon: _isUploading
                        //       ? const SizedBox(
                        //     height: 16,
                        //     width: 16,
                        //     child: CircularProgressIndicator(strokeWidth: 2),
                        //   )
                        //       : const Icon(Icons.upload, size: 18),
                        //   label: Text(_isUploading ? "Đang tải..." : "Chọn ảnh nhóm"),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm bạn bè...',
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Chọn thành viên',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredFriends.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final friend = filteredFriends[index];
                          final selected = vm.selectedUserIds.contains(friend.userId);
                          return CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            value: selected,
                            onChanged: _isCreating || _isUploading
                                ? null
                                : (_) => vm.toggleUserSelection(friend.userId),
                            title: Text(friend.displayName),
                            activeColor: AppStyles.primaryColor,
                            checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            secondary: CircleAvatar(
                              radius: 20,
                              backgroundImage: friend.avatar.isNotEmpty
                                  ? NetworkImage(friend.avatar)
                                  : null,
                              child: friend.avatar.isEmpty
                                  ? const Icon(Icons.person, color: Colors.white)
                                  : null,
                              backgroundColor: friend.avatar.isEmpty
                                  ? AppStyles.primaryColor
                                  : Colors.transparent,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isCreating || _isUploading ? null : _createGroup,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          foregroundColor: AppStyles.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isCreating
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : const Text('Tạo nhóm',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
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
    _nameController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
