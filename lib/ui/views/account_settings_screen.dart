import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield_settings.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const CustomTextFieldSettings(label: "Họ và tên"), // Đổi từ Full name
          const SizedBox(height: 16),
          const CustomTextFieldSettings(label: "Biệt danh"), // Đổi từ Username
          const SizedBox(height: 16),
          const CustomTextFieldSettings(label: "Bio", maxLines: 3), // Giữ nguyên
          const SizedBox(height: 24),

          // Nút cập nhật
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                // TODO: xử lý cập nhật thông tin
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Cập nhật",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
