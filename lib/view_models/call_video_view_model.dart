import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../config/agora_config.dart';

class CallVideoViewModel extends ChangeNotifier {
  late RtcEngine engine;
  int? remoteUid;
  bool localUserJoined = false;

  Future<void> initAgora({
    required String channelName,
    String? token,
  }) async {
    engine = createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(
      appId: AgoraConfig.appId,
    ));

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          localUserJoined = true;
          notifyListeners();
        },
        onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
          remoteUid = rUid;
          notifyListeners();
        },
        onUserOffline: (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
          remoteUid = null;
          notifyListeners();
        },
      ),
    );

    await engine.enableVideo();
    await engine.startPreview();

    await engine.joinChannel(
      token: token ?? "",
      channelId: channelName,
      uid: 0, // random UID, có thể truyền userId
      options: const ChannelMediaOptions(),
    );
  }

  void leaveChannel() async {
    await engine.leaveChannel();
    await engine.release();
  }
}
