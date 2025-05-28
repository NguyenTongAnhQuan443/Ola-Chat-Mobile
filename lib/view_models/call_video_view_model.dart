import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../config/agora_config.dart';

class CallVideoViewModel extends ChangeNotifier {
  late RtcEngine engine;
  int? remoteUid;
  bool localUserJoined = false;
  bool remoteVideoMuted = false;

  Future<void> initAgora({
    required String channelName,
    String? token,
  }) async {
    engine = createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(
      appId: AgoraConfig.appId,
    ));

    engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        localUserJoined = true;
        notifyListeners();
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        this.remoteUid = remoteUid;
        remoteVideoMuted = false;
        notifyListeners();
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        this.remoteUid = null;
        notifyListeners();
      },
      // Lắng nghe sự kiện tắt/mở camera của đối phương
      onUserMuteVideo: (RtcConnection connection, int remoteUid, bool muted) {
        this.remoteVideoMuted = muted;
        notifyListeners();
      },
    ));

    await engine.enableVideo();
    await engine.startPreview();

    await engine.joinChannel(
      token: token ?? '',
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  void leaveChannel() async {
    await engine.leaveChannel();
    await engine.release();
  }
}
