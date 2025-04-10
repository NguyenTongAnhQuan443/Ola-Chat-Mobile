import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';

class PhoneVerificationViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isOtpSent = false;
  String? error;

  Future<void> sendOtp(String phone) async {
    try {
      await _authService.sendOtp(phone);
      isOtpSent = true;
      error = null;
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      await _authService.verifyOtp(phone, otp);
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
