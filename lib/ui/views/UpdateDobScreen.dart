import 'package:flutter/material.dart';

class UpdateDobScreen extends StatelessWidget {
  const UpdateDobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime(2003, 4, 4);

    return Scaffold(
      appBar: AppBar(title: const Text("Cập nhật ngày sinh")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null && picked != selectedDate) {
                  selectedDate = picked;
                  // TODO: xử lý lưu ngày sinh mới
                }
              },
              child: const Text("Chọn ngày sinh"),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: submit ngày sinh
                },
                child: const Text("Lưu ngày sinh mới"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
