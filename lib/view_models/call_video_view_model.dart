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
    // 1. Khởi tạo Agora engine
    engine = createAgoraRtcEngine();
    await engine.initialize(
      const RtcEngineContext(appId: AgoraConfig.appId),
    );

    // 2. Đăng ký lắng nghe sự kiện
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          localUserJoined = true;
          notifyListeners();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          this.remoteUid = remoteUid;
          remoteVideoMuted = false;
          notifyListeners();
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          this.remoteUid = null;
          notifyListeners();
        },
        onUserMuteVideo: (RtcConnection connection, int remoteUid, bool muted) {
          remoteVideoMuted = muted;
          notifyListeners();
        },
      ),
    );

    // 3. Bật video local
    await engine.enableVideo();
    await engine.startPreview();

    // 4. Tham gia kênh (joinChannel tự động publish track)
    await engine.joinChannel(
      token: token ?? '',
      channelId: channelName,
      uid: 100, // có thể dùng userId hiện tại
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveChannel() async {
    await engine.leaveChannel();
    await engine.release();
    localUserJoined = false;
    remoteUid = null;
    remoteVideoMuted = false;
    notifyListeners();
  }

  // Tùy chọn mở rộng: tắt / bật camera local
  Future<void> toggleLocalVideo(bool enable) async {
    await engine.muteLocalVideoStream(!enable);
    notifyListeners();
  }

  // Tùy chọn mở rộng: tắt / bật mic
  Future<void> toggleLocalAudio(bool enable) async {
    await engine.muteLocalAudioStream(!enable);
    notifyListeners();
  }
}
