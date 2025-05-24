import 'package:flutter/material.dart';
import 'package:olachat_mobile/models/login_history_model.dart';
import 'package:olachat_mobile/services/user_service.dart';

class UserSettingInformationLoginHistoryViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  List<LoginHistoryModel> _items = [];
  bool _isLoading = false;
  String? _error;

  List<LoginHistoryModel> get items => _items;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> fetchHistory(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _userService.getLoginHistory(userId);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
  }
}
