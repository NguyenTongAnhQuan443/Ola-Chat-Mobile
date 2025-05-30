import 'package:flutter/material.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

class PrivacyDropdown extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  const PrivacyDropdown({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppStyles.primaryColor.withOpacity(0.4), width: 1),
        borderRadius: BorderRadius.circular(10),
        color: AppStyles.primaryColor.withOpacity(0.08),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black54, size: 20),
          isExpanded: true,
          borderRadius: BorderRadius.circular(10),
          dropdownColor: Colors.white,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          onChanged: onChanged,
          items: const [
            DropdownMenuItem(
              value: 'PUBLIC',
              child: Row(
                children: [
                  Icon(Icons.public, color: Colors.blue, size: 18),
                  SizedBox(width: 8),
                  Text("Công khai")
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'PRIVATE',
              child: Row(
                children: [
                  Icon(Icons.lock, color: Colors.grey, size: 18),
                  SizedBox(width: 8),
                  Text("Chỉ mình tôi")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
