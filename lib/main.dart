import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/views/SplashScreen.dart';
import 'package:olachat_mobile/view_models/login_view_model.dart';
import 'package:provider/provider.dart';
import 'ui/views/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OlaChat',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
