import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthService _authService;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SignUpViewModel({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<bool> register(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(data);
      return true;
    } catch (e) {
      _errorMessage = 'Lỗi khi đăng ký: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
