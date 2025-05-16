import 'package:flutter/widgets.dart';
import 'package:olachat_mobile/services/ping_service.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

class AppLifecycleHandler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("${AppStyles.phoneIcon}AppLifecycle: $state");

    if (state == AppLifecycleState.resumed) {
      print("${AppStyles.greenPointIcon}RESUMED → START ping");
      PingService.start();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      print("${AppStyles.redPointIcon}PAUSED/DETACHED → STOP ping");
      PingService.stop();
    }
  }
}
