import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/services/file_upload_service.dart';
import '../../data/services/token_service.dart';
import '../../view_models/create_group_view_model.dart';
import '../../core/utils/constants.dart';
import '../widgets/app_logo_header_one.dart';
class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _avatarUrl = '';
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CreateGroupViewModel>(context, listen: false).fetchFriends();
    });
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));

      final token = await TokenService.getAccessToken();
      final platformFile = PlatformFile(
        name: picked.name,
        path: picked.path,
        size: await picked.length(),
      );

      final urls = await FileUploadService.uploadFilesIndividually([platformFile], token!);
      if (urls.isNotEmpty) setState(() => _avatarUrl = urls.first);
    }
  }

  Future<void> _createGroup() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _avatarUrl.isEmpty) return;

    final vm = Provider.of<CreateGroupViewModel>(context, listen: false);
    final success = await vm.createGroup(name: name, avatarUrl: _avatarUrl);

    if (success && mounted) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tạo nhóm thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CreateGroupViewModel>(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const AppLogoHeaderOne(showBackButton: true),
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tạo nhóm chat",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _selectedImage != null
                            ? CircleAvatar(
                          radius: 32,
                          backgroundImage: FileImage(_selectedImage!),
                        )
                            : const CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.group, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF3EFFF),
                            foregroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          onPressed: _pickImage,
                          icon: const Icon(Icons.upload, size: 18),
                          label: const Text('Chọn ảnh nhóm'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Chọn thành viên',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 12),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: vm.friends.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final friend = vm.friends[index];
                        final selected = vm.selectedUserIds.contains(friend.userId);
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: selected,
                          onChanged: (_) =>
                              vm.toggleUserSelection(friend.userId),
                          title: Text(friend.displayName),
                          activeColor: Colors.deepPurple,
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          secondary: CircleAvatar(
                            radius: 20,
                            backgroundImage: friend.avatar.isNotEmpty
                                ? NetworkImage(friend.avatar)
                                : null,
                            child: friend.avatar.isEmpty
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                            backgroundColor:
                            friend.avatar.isEmpty ? Colors.purple : Colors.transparent,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _createGroup,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFFF3EFFF),
                          foregroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Tạo nhóm',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 24),
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
    super.dispose();
  }
}
