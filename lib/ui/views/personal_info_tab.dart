import 'package:flutter/material.dart';

import 'UpdateDobScreen.dart';
import 'UpdateEmailScreen.dart';
import 'UpdatePasswordScreen.dart';

class PersonalInfoTab extends StatelessWidget {
  const PersonalInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final info = {
      'Số điện thoại': '0365962232',
      'Email': 'ntanhquan.sly@gmail.com',
      'Ngày sinh': '04/04/2003',
      'Ngày tạo tài khoản': '11/04/2025',
    };

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin cá nhân',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          buildInfoTile('Số điện thoại', info['Số điện thoại']!),
          buildInfoTile('Email', info['Email']!, onEdit: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => const UpdateEmailScreen(),
            ));
          }),
          buildInfoTile('Ngày sinh', info['Ngày sinh']!, onEdit: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => const UpdateDobScreen(),
            ));
          }),

          const SizedBox(height: 16),
          // Dòng cập nhật mật khẩu
          buildInfoTile('Mật khẩu', '********', onEdit: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => const UpdatePasswordScreen(),
            ));
          }),
        ],
      ),
    );
  }

  Widget buildInfoTile(String label, String value, {VoidCallback? onEdit}) {
    return InkWell(
      onTap: onEdit,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: "$label\n",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  children: [
                    TextSpan(
                      text: value,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (onEdit != null)
              const Icon(Icons.edit, size: 18, color: Colors.blue),
          ],
        ),
      ),
    );
  }


}
