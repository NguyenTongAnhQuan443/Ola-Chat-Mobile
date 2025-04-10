import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  String? error;

  Future<bool> register(Map<String, dynamic> data) async {
    try {
      await _authService.register(data);
      error = null;
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
