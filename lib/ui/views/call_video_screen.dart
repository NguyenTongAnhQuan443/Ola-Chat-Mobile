import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:provider/provider.dart';

import '../../view_models/call_video_view_model.dart';

class CallVideoScreen extends StatefulWidget {
  final String channelName;
  final String? token;
  final String? avatarRemoteUrl; // avatar đối phương truyền vào

  const CallVideoScreen({
    super.key,
    required this.channelName,
    this.token,
    this.avatarRemoteUrl,
  });

  @override
  State<CallVideoScreen> createState() => _CallVideoScreenState();
}

class _CallVideoScreenState extends State<CallVideoScreen> {
  late CallVideoViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = CallVideoViewModel();
    _init();
  }

  Future<void> _init() async {
    // Request permissions...
    await vm.initAgora(
      channelName: widget.channelName,
      token: widget.token,
    );
    setState(() {});
  }

  @override
  void dispose() {
    vm.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Consumer<CallVideoViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // ----- REMOTE VIDEO (FULL SCREEN) -----
                Positioned.fill(
                  child: vm.remoteUid != null && !vm.remoteVideoMuted
                      ? AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: vm.engine,
                      canvas: VideoCanvas(uid: vm.remoteUid),
                      connection: RtcConnection(channelId: widget.channelName),
                    ),
                  )
                      : Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: widget.avatarRemoteUrl != null
                          ? NetworkImage(widget.avatarRemoteUrl!)
                          : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                    ),
                  ),
                ),
                // ----- LOCAL VIDEO (TOP-RIGHT CORNER) -----
                Positioned(
                  top: 40,
                  right: 16,
                  child: vm.localUserJoined
                      ? Container(
                    width: 100,
                    height: 140,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: vm.engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      ),
                    ),
                  )
                      : Container(
                    width: 100,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                // ----- END CALL BUTTON -----
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.call_end),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
