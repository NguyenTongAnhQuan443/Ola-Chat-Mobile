import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:olachat_mobile/ui/views/messages_conversation_screen.dart';
import 'package:olachat_mobile/view_models/create_group_view_model.dart';
import 'package:olachat_mobile/view_models/group_management_view_model.dart';
import 'package:olachat_mobile/view_models/list_conversation_view_model.dart';
import 'package:olachat_mobile/view_models/friend_request_view_model.dart';
import 'package:olachat_mobile/view_models/message_conversation_view_model.dart';
import 'package:olachat_mobile/view_models/notification_view_model.dart';

import 'appInterceptors.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/utils/app_lifecycle_handler.dart';
import 'ui/views/splash_screen.dart';
import 'view_models/login_view_model.dart';
import 'view_models/forgot_password_view_model.dart';
import 'view_models/phone_verification_view_model.dart';
import 'view_models/reset_password_view_model.dart';
import 'view_models/signup_view_model.dart';
import 'view_models/search_view_model.dart';
import 'view_models/user_setting_avatar_view_model.dart';

late Dio dio;
// GLOBAL
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final AppLifecycleHandler lifecycleHandler = AppLifecycleHandler();
  WidgetsBinding.instance.addObserver(lifecycleHandler);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Cấu hình hiển thị local notification
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);
  // Khi app đang mở
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification!.title,
        message.notification!.body,
        NotificationDetails(
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

  dio = Dio();
  dio.interceptors.add(AppInterceptors(dio));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => PhoneVerificationViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => ResetPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => UserSettingAvatarViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => FriendRequestViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => ListConversationViewModel()),
        ChangeNotifierProvider(create: (_) => CreateGroupViewModel()),
        ChangeNotifierProvider(create: (_) => GroupManagementViewModel()),
        ChangeNotifierProvider(
          create: (_) => MessageConversationViewModel(),
          child: MessagesConversationScreen(
            conversationId: "...",
            conversationName: "...",
            avatarUrl: "...",
          ),
        )

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'OlaChat',
      home: const SplashScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', 'VN'),
      ],
    );
  }
}
