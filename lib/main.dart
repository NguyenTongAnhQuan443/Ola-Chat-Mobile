import 'package:flutter/material.dart';
import 'package:olachat_mobile/view_models/add_group_members_view_model.dart';
import 'package:olachat_mobile/view_models/create_group_view_model.dart';
import 'package:olachat_mobile/view_models/feed_view_model.dart';
import 'package:olachat_mobile/view_models/list_conversation_view_model.dart';
import 'package:olachat_mobile/view_models/friend_request_view_model.dart';
import 'package:olachat_mobile/view_models/message_conversation_view_model.dart';
import 'package:olachat_mobile/view_models/notification_view_model.dart';
import 'package:olachat_mobile/view_models/phone_verification_view_model.dart';
import 'package:olachat_mobile/view_models/post_create_view_model.dart';
import 'package:olachat_mobile/view_models/socket_view_model.dart';
import 'package:olachat_mobile/view_models/update_email_view_model.dart';
import 'package:olachat_mobile/view_models/update_password_view_model.dart';
import 'package:olachat_mobile/view_models/user_setting_information_login_history_view_model.dart';
import 'package:olachat_mobile/view_models/user_setting_introduce_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ui/views/splash_screen.dart';
import 'view_models/login_view_model.dart';
import 'view_models/forgot_password_view_model.dart';
import 'view_models/reset_password_view_model.dart';
import 'view_models/signup_view_model.dart';
import 'view_models/search_view_model.dart';
import 'view_models/user_setting_avatar_view_model.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => PhoneVerificationViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => ResetPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => UserSettingAvatarViewModel()),
        ChangeNotifierProvider(create: (_) => UserSettingIntroduceViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => UpdateEmailViewModel()),
        ChangeNotifierProvider(create: (_) => UpdatePasswordViewModel()),
        ChangeNotifierProvider(create: (_) => UserSettingInformationLoginHistoryViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => ListConversationViewModel()),
        ChangeNotifierProvider(create: (_) => MessageConversationViewModel()),
        ChangeNotifierProvider(create: (_) => CreateGroupViewModel()),
        ChangeNotifierProvider(create: (_) => FriendRequestViewModel()),
        ChangeNotifierProvider(create: (_) => PostCreateViewModel()),
        ChangeNotifierProvider(create: (_) => FeedViewModel()),
        ChangeNotifierProvider(create: (_) => FriendRequestViewModel()),

        ChangeNotifierProvider(create: (_) => AddGroupMembersViewModel()),

        // ChangeNotifierProvider(create: (_) => GroupManagementViewModel()),
        // ChangeNotifierProvider(create: (_) => GroupMembersViewModel()),
        // ChangeNotifierProvider(create: (_) => GroupMembersRoleViewModel()),

        // ChangeNotifierProvider(
        //   create: (_) => MessageConversationViewModel(),
        //   child: MessagesConversationScreen(
        //     conversationId: "...",
        //     conversationName: "...",
        //     avatarUrl: "...",
        //   ),
        // )
      ],
      child: const MyApp(),
    ),
  );
}

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      title: 'OlaChat',
      home: const SplashScreen(),
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
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
