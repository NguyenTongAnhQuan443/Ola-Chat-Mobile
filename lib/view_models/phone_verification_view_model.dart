import 'package:flutter/material.dart';
import 'package:olachat_mobile/services/auth_service.dart';

class PhoneVerificationViewModel extends ChangeNotifier {
  final AuthService _authService;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  PhoneVerificationViewModel({AuthService? authService})
      : _authService = authService ?? AuthService();

  bool isValidPhone(String phone) {
    final trimmed = phone.trim();
    final regex = RegExp(r'^0\d{9}$');
    return regex.hasMatch(trimmed);
  }

  Future<bool> sendOtp(String phone) async {
    if (!isValidPhone(phone)) {
      _errorMessage =
          "Số điện thoại không hợp lệ. Phải bắt đầu bằng số 0 và đủ 10 chữ số.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendOtp(phone, provider: "vonage");
      return true;
    } catch (e) {
      _errorMessage = "Lỗi gửi OTP: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    if (!isValidPhone(phone) || otp.trim().isEmpty) {
      _errorMessage = "Vui lòng nhập đúng số điện thoại và mã OTP.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.verifyOtp(phone, otp, provider: "vonage");
      return true;
    } catch (e) {
      _errorMessage = "Lỗi xác thực OTP: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
