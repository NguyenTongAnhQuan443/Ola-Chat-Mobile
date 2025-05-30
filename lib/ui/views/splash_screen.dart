import 'package:flutter/material.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../services/ping_service.dart';
import '../../utils/firebase_options.dart';
import '../../view_models/login_view_model.dart';
import '../views/login_screen.dart';
import '../views/bottom_navigationbar_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      debugPrint("${AppStyles.connectIcon}[SplashScreen] Bắt đầu khởi tạo Firebase...");
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      debugPrint("${AppStyles.successIcon}[SplashScreen] Firebase khởi tạo thành công");

      // Cấp quyền nếu cần (Android 13+)
      await _requestNotificationPermission();

      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);
      await flutterLocalNotificationsPlugin.initialize(initSettings);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          flutterLocalNotificationsPlugin.show(
            message.hashCode,
            message.notification!.title,
            message.notification!.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'default_channel',
                'Thông báo',
                importance: Importance.max,
                priority: Priority.high,
              ),
            ),
          );
        }
      });

      debugPrint("${AppStyles.wattingIcon}[SplashScreen] Bắt đầu kiểm tra đăng nhập...");
      final loginVM = Provider.of<LoginViewModel>(context, listen: false);
      final success = await loginVM.validateAndFetchUserInfo();

      if (!mounted) return;
      if (success) {
        debugPrint("${AppStyles.successIcon}[SplashScreen] Đã đăng nhập, chuyển sang Home");
        PingService.start();
        _goToHome();
      } else {
        debugPrint("${AppStyles.warningIcon}[SplashScreen] Chưa đăng nhập, chuyển sang Login");
        _goToLogin();
      }
    } catch (e, s) {
      debugPrint("${AppStyles.redPointIcon} Lỗi khởi tạo SplashScreen: $e\n$s");
      _goToLogin();
    }
  }

  Future<void> _requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
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
