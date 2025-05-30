import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:olachat_mobile/view_models/post_create_view_model.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header_one.dart';
import '../widgets/privacy_dropdown.dart';
import '../widgets/show_snack_bar.dart';

class FormPostScreen extends StatefulWidget {
  const FormPostScreen({super.key});

  @override
  State<FormPostScreen> createState() => _FormPostScreenState();
}

class _FormPostScreenState extends State<FormPostScreen> {
  final _contentController = TextEditingController();
  String _privacy = 'PUBLIC';
  List<File> _selectedFiles = [];

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.media,
    );

    if (result != null) {
      setState(() {
        _selectedFiles = result.paths.map((path) => File(path!)).toList();
      });
    }
  }

  Future<void> _handleSubmit() async {
    final vm = Provider.of<PostCreateViewModel>(context, listen: false);
    final content = _contentController.text.trim();

    if (content.isEmpty) {
      showErrorSnackBar(context, '❗ Nội dung không được để trống');
      return;
    }

    final success = await vm.createPost(
      content: content,
      privacy: _privacy,
      files: _selectedFiles,
    );

    if (success && mounted) {
      Navigator.pop(context);
      showSuccessSnackBar(context, 'Đăng bài thành công!');
    } else {
      showErrorSnackBar(context, 'Đăng bài thất bại');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PostCreateViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const AppLogoHeaderOne(showBackButton: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _contentController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Bạn đang nghĩ gì?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    PrivacyDropdown(
                      value: _privacy,
                      onChanged: (value) => setState(() => _privacy = value!),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _pickFiles,
                      icon: const Icon(Icons.image_outlined, size: 20),
                      label: const Text("Chọn ảnh/video"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade50,
                        foregroundColor: AppStyles.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_selectedFiles.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedFiles
                            .map((file) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            file,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ))
                            .toList(),
                      ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: vm.isPosting ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyles.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                        child: vm.isPosting
                            ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        )
                            : const Text(
                          "Đăng bài",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
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

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
