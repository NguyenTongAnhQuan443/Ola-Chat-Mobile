import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:olachat_mobile/view_models/login_view_model.dart';
import 'package:provider/provider.dart';

import 'update_dob_screen.dart';
import 'update_email_screen.dart';
import 'update_password_screen.dart';

class PersonalInfoTab extends StatelessWidget {
  const PersonalInfoTab({super.key});

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<LoginViewModel>(context).userInfo;

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

          buildInfoTile('Số điện thoại', userInfo?['username'] ?? ''),
          buildInfoTile('Email', userInfo?['email'] ?? '', onEdit: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => const UpdateEmailScreen(),
            ));
          }),
          buildInfoTile('Ngày sinh', formatDate(userInfo?['dob']), onEdit: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => const UpdateDobScreen(),
            ));
          }),
          buildInfoTile('Mật khẩu', '********', onEdit: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => const UpdatePasswordScreen(),
            ));
          }),
          buildInfoTile('Ngày tạo tài khoản', formatDate(userInfo?['createdAt'])),
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
