import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:olachat_mobile/services/ping_service.dart';
import 'package:olachat_mobile/services/token_service.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

class AppLifecycleHandler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("${AppStyles.phoneIcon}AppLifecycle: $state");

    if (state == AppLifecycleState.resumed) {
      final token = await TokenService.getAccessToken();
      if (token != null) {
        print("${AppStyles.greenPointIcon}RESUMED → START ping");
        PingService.start();
      } else {
        print("${AppStyles.warningIcon}Không có token. Không ping.");
      }
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      print("${AppStyles.redPointIcon}PAUSED/DETACHED → STOP ping");
      PingService.stop();
    }
  }
}
