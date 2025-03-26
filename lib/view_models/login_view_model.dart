import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data/models/auth_model.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;

  LoginViewModel({AuthService? authService})
      : _authService = authService ?? AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  AuthResponse? _authResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthResponse? get authResponse => _authResponse;

  Future<void> _handleLogin(Future<AuthResponse> Function() loginMethod) async {
    _isLoading = true;
    notifyListeners();

    try {
      _authResponse = await loginMethod();
      _errorMessage = null;
    } catch (e, stack) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithFacebook() async {
    final result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final accessToken = result.accessToken!.tokenString;
      await _handleLogin(() => _authService.loginWithFacebook(accessToken));
    } else {
      _errorMessage = 'Đăng nhập Facebook thất bại';
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
      serverClientId: '714231235616-gorl6sl5fja3tgja1pfl9la9qd3b9orf.apps.googleusercontent.com',
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      _errorMessage = 'Hủy đăng nhập Google';
      notifyListeners();
      return;
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      _errorMessage = 'Không lấy được ID Token';
      notifyListeners();
      return;
    }

    await _handleLogin(() => _authService.loginWithGoogle(idToken));
  }

  Future<void> loginWithPhone(String username, String password) async {
    await _handleLogin(() => _authService.loginWithPhone(username, password));
  }
}
