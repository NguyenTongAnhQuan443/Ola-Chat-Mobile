import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier{
  bool isLoading = false;
  bool isAgreed = false;

  void toggleAgreement(bool value){
    isLoading = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async{
    isLoading = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 2)); //
    isLoading = false;
    notifyListeners();
  }
  
  Future<void> signUp(String name, String email, String userName, String password) async{
    isLoading = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 2)); //
    isLoading = false;
    notifyListeners();
  }
}