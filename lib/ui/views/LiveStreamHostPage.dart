import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LiveStreamHostPage extends StatelessWidget {
  const LiveStreamHostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltLiveStreaming(
      appID: 1624026406,
      appSign: "07be86dda37952668ba1b7f0d4b6d00fab31f511f6dd1db49cd5d5099433d0c2",
      userID: "user_123",
      userName: "Nguyễn Tống Anh Quân",
      liveID: "123",
      config: ZegoUIKitPrebuiltLiveStreamingConfig.host(),
    );
  }
}
