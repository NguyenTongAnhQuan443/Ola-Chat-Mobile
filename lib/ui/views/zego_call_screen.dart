import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ZegoCallScreen extends StatelessWidget {
  final String userId;
  final String userName;
  final String callID;
  final bool isVideoCall;

  const ZegoCallScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.callID,
    required this.isVideoCall,
  });

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 1156880137,
      appSign: '5531bb962ce40abc4d6036f8729941950d8ca8f0853effd9c9908ae4e532af9e',
      userID: userId,
      userName: userName,
      callID: callID,
      config: isVideoCall
          ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
    );
  }
}
