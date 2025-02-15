import 'package:flutter/material.dart';

class CustomSocialButton extends StatelessWidget {
  final String iconPath;
  final String nameButton;

  const CustomSocialButton(
      {super.key, required this.iconPath, required this.nameButton});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Image.asset(
          iconPath,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.error,
            color: Colors.red,
          ),
        ),
        label: Text(nameButton, style: TextStyle(fontSize: 14)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: Colors.grey.shade300),
          elevation: 0,
        ),
      ),
    );
  }
}
