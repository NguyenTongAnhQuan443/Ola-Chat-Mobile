import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olachat_mobile/ui/views/feed_screen.dart';
import 'package:olachat_mobile/ui/views/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final token = prefs.getString('access_token');

    if (token == null) {
      _goToLogin();
      return;
    }

    // Gọi API introspect token
    final url = Uri.parse('http://10.0.2.2:8080/ola-chat/auth/introspect');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token}),
    );

    final body = jsonDecode(res.body);
    final isValid = body['success'] == true;

    if (res.statusCode == 200 && isValid) {
      _goToFeed();
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _goToFeed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const FeedScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
