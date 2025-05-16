import 'package:flutter/material.dart';
import 'package:olachat_mobile/services/ping_service.dart';
import 'package:provider/provider.dart';
import 'package:olachat_mobile/ui/views/login_screen.dart';
import 'package:olachat_mobile/ui/views/bottom_navigationbar_screen.dart';
import 'package:olachat_mobile/view_models/login_view_model.dart';

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
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    final success = await loginVM.validateAndFetchUserInfo();

    if (success) {
      PingService.start();
      _goToHome();
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
