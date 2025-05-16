import 'package:flutter/material.dart';
import 'package:olachat_mobile/services/auth_service.dart';

class PhoneVerificationViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isOtpSent = false;
  String? error;

  Future<void> sendOtp(String phone) async {
    try {
      await _authService.sendOtp(phone, provider: "twillio");
      // await _authService.sendOtp(phone, provider: "vonage");
      isOtpSent = true;
      error = null;
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      await _authService.verifyOtp(phone, otp, provider: "twillio");
      // await _authService.verifyOtp(phone, otp, provider: "vonage");
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
