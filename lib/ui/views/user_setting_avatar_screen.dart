import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olachat_mobile/view_models/user_setting_avatar_view_model.dart';
import 'package:provider/provider.dart';

class UserSettingAvatarScreen extends StatelessWidget {
  // UI Cập nhập avatar
  const UserSettingAvatarScreen({super.key});

  Future<void> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Provider.of<ProfileViewModel>(context, listen: false)
          .selectImage(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, vm, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: GestureDetector(
                  onTap: () => pickImage(context),
                  child: DottedBorder(
                    color: Colors.grey.shade400,
                    strokeWidth: 1.5,
                    dashPattern: [6, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 270,
                      child: vm.selectedImage != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          vm.selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.cloud_upload_outlined,
                              color: Colors.black87, size: 20),
                          SizedBox(width: 10),
                          Text(
                            "Tải ảnh đại diện lên",
                            style: TextStyle(
                                color: Colors.black87, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () => vm.updateAvatar(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                    elevation: 0,
                  ),
                  child: vm.isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text("Cập nhật",
                      style: TextStyle(fontSize: 14)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
