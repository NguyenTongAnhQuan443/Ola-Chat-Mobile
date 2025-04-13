import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
as dp;
import 'package:intl/intl.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header.dart';
import 'package:olachat_mobile/ui/widgets/show_snack_bar.dart';
import 'package:olachat_mobile/view_models/login_view_model.dart';
import 'package:provider/provider.dart';
import '../../core/utils/constants.dart';
import '../../data/services/User_service.dart';

class UpdateDobScreen extends StatefulWidget {
  const UpdateDobScreen({super.key});

  @override
  State<UpdateDobScreen> createState() => _UpdateDobScreenState();
}

class _UpdateDobScreenState extends State<UpdateDobScreen> {
  DateTime selectedDate = DateTime(2003, 4, 4);
  bool isLoading = false;

  String get formattedDate => DateFormat('dd/MM/yyyy').format(selectedDate);

  Future<void> _pickDate() async {
    dp.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900),
      maxTime: DateTime.now(),
      currentTime: selectedDate,
      locale: dp.LocaleType.vi,
      onConfirm: (date) {
        setState(() => selectedDate = date);
      },
    );
  }

  bool _isAtLeast18YearsOld(DateTime date) {
    final now = DateTime.now();
    final age = now.year - date.year -
        ((now.month < date.month || (now.month == date.month && now.day < date.day)) ? 1 : 0);
    return age >= 18;
  }

  Future<void> _submit() async {
    if (!_isAtLeast18YearsOld(selectedDate)) {
      showErrorSnackBar(context, "Bạn phải đủ 18 tuổi trở lên để cập nhật ngày sinh.");
      return;
    }

    setState(() => isLoading = true);

    try {
      final formattedDob = DateFormat('dd/MM/yyyy').format(selectedDate);
      final data = {
        "dob": formattedDob,
      };
      await UserService().updateProfile(data);
      await Provider.of<LoginViewModel>(context, listen: false)
          .refreshUserInfo();

      showSuccessSnackBar(context, "Cập nhật ngày sinh thành công");
      Navigator.pop(context);
    } catch (e) {
      showErrorSnackBar(context, "Lỗi cập nhật ngày sinh");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              AppLogoHeader(showBackButton: false),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/dob.svg',
                      height: 300,
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: _pickDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formattedDate,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const Icon(Icons.calendar_today, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                            AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                            : const Text("Lưu ngày sinh mới",
                            style: TextStyle(fontSize: 14)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Quay lại",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
