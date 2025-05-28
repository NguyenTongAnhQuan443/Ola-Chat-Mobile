import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../view_models/call_video_view_model.dart';

class CallVideoScreen extends StatefulWidget {
  final String channelName; // dùng conversationId hoặc custom string
  final String? token;
  final String? avatarUrl;

  const CallVideoScreen({
    super.key,
    required this.channelName,
    this.token,
    this.avatarUrl,
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

  // Xin quyền
  Future<void> _initPermissions() async {
    await [Permission.camera, Permission.microphone].request();
  }

  Future<void> _init() async {
    await [Permission.camera, Permission.microphone].request();
    await _initPermissions();
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
                Center(
                  child: vm.localUserJoined
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: vm.engine,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
                if (vm.remoteUid != null)
                  Align(
                    alignment: Alignment.topLeft,
                    child: vm.remoteVideoMuted
                        ? Container(
                            color: Colors.grey[900],
                            child: Center(
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: widget.avatarUrl != null &&
                                        widget.avatarUrl!.isNotEmpty
                                    ? NetworkImage(widget.avatarUrl!)
                                    : const AssetImage(
                                            'assets/images/default_avatar.png')
                                        as ImageProvider,
                              ),
                            ),
                          )
                        : AgoraVideoView(
                            controller: VideoViewController.remote(
                              rtcEngine: vm.engine,
                              canvas: VideoCanvas(uid: vm.remoteUid),
                              connection:
                                  RtcConnection(channelId: widget.channelName),
                            ),
                          ),
                  ),
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
