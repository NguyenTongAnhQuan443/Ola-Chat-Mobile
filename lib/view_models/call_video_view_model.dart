import 'dart:math';

import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../config/agora_config.dart';

class CallVideoViewModel extends ChangeNotifier {
  late RtcEngine engine;

  int? remoteUid;
  bool localUserJoined = false;
  bool remoteVideoMuted = false;

  // Trạng thái bật/tắt camera, mic
  bool isCameraEnabled = true;
  bool isMicEnabled = true;

  Future<void> initAgora({
    required String channelName,
    String? token,
  }) async {
    engine = createAgoraRtcEngine();
    await engine.initialize(
      const RtcEngineContext(appId: AgoraConfig.appId),
    );
    await engine.enableVideo();
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          localUserJoined = true;
          debugPrint('🟢 [Local] Đã join channel: ${connection.channelId}, uid: ${connection.localUid}');
          notifyListeners();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          this.remoteUid = remoteUid;
          remoteVideoMuted = false;
          debugPrint('🔵 [Remote] Có user mới join: $remoteUid vào channel: ${connection.channelId}');
          notifyListeners();
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          this.remoteUid = null;
          debugPrint('🔴 [Remote] User rời khỏi: $remoteUid, lý do: $reason');
          notifyListeners();
        },
        onUserMuteVideo: (RtcConnection connection, int remoteUid, bool muted) {
          remoteVideoMuted = muted;
          notifyListeners();
        },
      ),
    );
    await engine.startPreview();
    await engine.joinChannel(
      token: token ?? '',
      channelId: channelName,
      uid: Random().nextInt(999999),
      options: const ChannelMediaOptions(
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),

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

  // Toggle camera
  Future<void> toggleLocalVideo() async {
    isCameraEnabled = !isCameraEnabled;
    await engine.muteLocalVideoStream(!isCameraEnabled);
    notifyListeners();
  }

  // Toggle mic
  Future<void> toggleLocalAudio() async {
    isMicEnabled = !isMicEnabled;
    await engine.muteLocalAudioStream(!isMicEnabled);
    notifyListeners();
  }

  @override
  void dispose() {
    leaveChannel(); // đảm bảo thoát và giải phóng engine
    super.dispose();
  }

}
