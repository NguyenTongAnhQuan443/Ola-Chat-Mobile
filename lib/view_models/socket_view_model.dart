import 'package:flutter/material.dart';
import 'package:olachat_mobile/services/socket_service.dart';
import 'package:olachat_mobile/services/token_service.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

class SocketViewModel extends ChangeNotifier {
  final SocketService _socketService = SocketService();

  void initSocketConnection(String accessToken) async {
    _socketService.init(accessToken, onConnectCallback: () async {
      final userId = await TokenService.getCurrentUserId();
      if (userId != null) {
        _socketService.subscribe('/user/$userId/private', (data) {
          print('${AppStyles.successIcon}[SOCKET] Nhận tin nhắn mới: $data');
        });
      }
    });
  }
}
