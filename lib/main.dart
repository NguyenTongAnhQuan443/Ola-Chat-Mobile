import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/views/splash_screen.dart';
import 'package:olachat_mobile/view_models/forgot_password_view_model.dart';
import 'package:olachat_mobile/view_models/login_view_model.dart';
import 'package:olachat_mobile/view_models/phone_verification_view_model.dart';
import 'package:olachat_mobile/view_models/profile_view_model.dart';
import 'package:olachat_mobile/view_models/reset_password_view_model.dart';
import 'package:olachat_mobile/view_models/search_view_model.dart';
import 'package:olachat_mobile/view_models/signup_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/utils/app_lifecycle_handler.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final AppLifecycleHandler _lifecycleHandler = AppLifecycleHandler();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AppLifecycleHandler lifecycleHandler = AppLifecycleHandler();
  WidgetsBinding.instance.addObserver(lifecycleHandler);
  print("📲 AppLifecycleHandler added");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => PhoneVerificationViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => ResetPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),

      ],
      child: MyApp(),
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
      title: 'OlaChat',
      debugShowCheckedModeBanner: false,
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
