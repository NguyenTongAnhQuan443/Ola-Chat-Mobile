import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olachat_mobile/ui/views/login_screen.dart';
import 'package:olachat_mobile/ui/views/bottom_navigationbar_screen.dart';
import 'package:olachat_mobile/view_models/login_view_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:olachat_mobile/core/utils/config/api_config.dart';

import '../../data/services/ping_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    PingService.start();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');

    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    if (accessToken == null && refreshToken == null) {
      _goToLogin();
      return;
    }

    bool isValid = false;

    if (accessToken != null) {
      try {
        final res = await http.post(
          Uri.parse('${ApiConfig.base}/auth/introspect'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'token': accessToken}),
        );
        final body = jsonDecode(res.body);
        isValid = body['success'] == true;
      } catch (e) {
        debugPrint('❌ Lỗi introspect token: $e');
      }
    }

    if (isValid) {
      try {
        await loginVM.refreshUserInfo();
        _goToHome();
      } catch (e) {
        _goToLogin();
      }
    } else {
      final refreshed = await loginVM.tryRefreshToken();
      if (refreshed) {
        try {
          await loginVM.refreshUserInfo();
          _goToHome();
        } catch (e) {
          _goToLogin();
        }
      } else {
        _goToLogin();
      }
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const BottomNavigationBarScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
