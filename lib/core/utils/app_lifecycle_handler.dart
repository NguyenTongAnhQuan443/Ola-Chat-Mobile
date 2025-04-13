import 'package:flutter/widgets.dart';

import '../../data/services/ping_service.dart';

class AppLifecycleHandler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("📱 AppLifecycle: $state");

    if (state == AppLifecycleState.resumed) {
      print("🟢 RESUMED → START ping");
      PingService.start();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      print("🔴 PAUSED/DETACHED → STOP ping");
      PingService.stop();
    }
  }
}
