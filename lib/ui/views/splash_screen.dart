import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olachat_mobile/ui/views/login_screen.dart';
import 'package:olachat_mobile/ui/views/bottom_navigationbar_screen.dart';
import 'package:olachat_mobile/view_models/login_view_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:olachat_mobile/core/config/api_config.dart';

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
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    bool isValid = false;
    if (accessToken != null) {
      final res = await http.post(
        Uri.parse('${ApiConfig.base}/auth/introspect'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': accessToken}),
      );
      final body = jsonDecode(res.body);
      isValid = body['success'] == true;
    }

    if (isValid) {
      _goToHome();
    } else {
      final refreshed = await Provider.of<LoginViewModel>(context, listen: false).tryRefreshToken();
      if (refreshed) {
        _goToHome();
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
