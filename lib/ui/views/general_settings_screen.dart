import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/widgets/custom_textfield_settings.dart';

class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
            child: GestureDetector(
                onTap: () {},
                child: DottedBorder(
                  color: Colors.grey.shade400,
                  // Màu viền nét đứt
                  strokeWidth: 1.5,
                  // Độ dày của nét đứt
                  dashPattern: [6, 3],
                  // Mẫu nét đứt: 6px nét, 3px khoảng trống
                  borderType: BorderType.RRect,
                  // Bo góc viền
                  radius: Radius.circular(8),
                  // Độ cong viền
                  child: SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          color: Colors.black87,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Choose an image for avatar",
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          SizedBox(height: 16),
          CustomTextFieldSettings(label: "Full name"),
          SizedBox(height: 16),
          CustomTextFieldSettings(label: "Username"),
          SizedBox(height: 16),
          CustomTextFieldSettings(label: "Bio", maxLines: 3),
        ],
      ),
    );
  }
}
