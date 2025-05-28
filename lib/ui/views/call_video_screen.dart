import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../view_models/call_video_view_model.dart';

class CallVideoScreen extends StatefulWidget {
  final String channelName;
  final String? token;
  final String? avatarRemoteUrl;

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

  // Xin quyền camera và micro
  Future<bool> requestCameraAndMicPermissions() async {
    var statusCamera = await Permission.camera.request();
    var statusMic = await Permission.microphone.request();

    return statusCamera.isGranted && statusMic.isGranted;
  }

  Future<void> _init() async {
    bool permissionsGranted = await requestCameraAndMicPermissions();
    if (!permissionsGranted) {
      // Hiển thị thông báo cho user biết cần quyền camera/mic
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bạn cần cấp quyền Camera và Micro để gọi video!')),
        );
      }
      return;
    }
    debugPrint('${AppStyles.successIcon} [CallVideoScreen] Join channel: ${widget.channelName}');
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
                // REMOTE VIDEO (FULL SCREEN)
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
                      backgroundImage: (widget.avatarRemoteUrl != null && widget.avatarRemoteUrl!.isNotEmpty)
                          ? NetworkImage(widget.avatarRemoteUrl!)
                          : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                    ),
                  ),
                ),
                // LOCAL VIDEO (TOP-RIGHT CORNER)
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
                      child: vm.isCameraEnabled
                          ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: vm.engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                          : Container(
                        color: Colors.black,
                        child: Center(
                          child: Icon(Icons.videocam_off, color: Colors.white, size: 36),
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
                // CONTROL BUTTONS (BOTTOM CENTER)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Toggle camera
                        FloatingActionButton(
                          heroTag: "camera",
                          backgroundColor: vm.isCameraEnabled ? Colors.white : Colors.grey,
                          child: Icon(
                            vm.isCameraEnabled ? Icons.videocam : Icons.videocam_off,
                            color: vm.isCameraEnabled ? Colors.blue : Colors.black54,
                          ),
                          onPressed: () => vm.toggleLocalVideo(),
                        ),
                        const SizedBox(width: 30),
                        // End call
                        FloatingActionButton(
                          heroTag: "endcall",
                          backgroundColor: Colors.red,
                          child: const Icon(Icons.call_end),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 30),
                        // Toggle mic
                        FloatingActionButton(
                          heroTag: "mic",
                          backgroundColor: vm.isMicEnabled ? Colors.white : Colors.grey,
                          child: Icon(
                            vm.isMicEnabled ? Icons.mic : Icons.mic_off,
                            color: vm.isMicEnabled ? Colors.blue : Colors.black54,
                          ),
                          onPressed: () => vm.toggleLocalAudio(),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 0, right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Consumer<CallVideoViewModel>(
                        builder: (_, vm, __) {
                          if (vm.remoteUid != null) {
                            return Text(
                              '✅ Đối phương đã vào phòng (UID: ${vm.remoteUid})',
                              style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                            );
                          } else {
                            return const Text(
                              '⏳ Đang chờ đối phương vào phòng...',
                              style: TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.bold),
                            );
                          }
                        },
                      ),
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
