import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.isPassword = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          border: _borderStyle,
          // Viền khi không focus
          enabledBorder: _borderStyle,
          // Viền khi focus
          focusedBorder: _borderStyle.copyWith(
            borderSide: BorderSide(color: Colors.grey.shade500, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
              // Padding trong ô nhập
              horizontal: 20),
          filled: true,
          fillColor: Colors.white,
          // Nếu là mật khẩu thì hiển thị nút bật/tắt
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                )
              : null,
        ),
        style: const TextStyle(fontSize: 16),
        // Không che nội dung nhập
      ),
    );
  }
}

OutlineInputBorder get _borderStyle => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5));
