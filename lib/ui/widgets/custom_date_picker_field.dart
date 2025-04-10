import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePickerField extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const CustomDatePickerField({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return SizedBox(
      height: 44,
      child: TextField(
        readOnly: true,
        onTap: onTap,
        controller: TextEditingController(
          text: selectedDate != null ? dateFormat.format(selectedDate!) : '',
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          border: _borderStyle,
          enabledBorder: _borderStyle,
          focusedBorder: _borderStyle.copyWith(
            borderSide: BorderSide(color: Colors.grey.shade500, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  OutlineInputBorder get _borderStyle => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
  );
}
