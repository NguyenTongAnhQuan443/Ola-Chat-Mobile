import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorderService {
  static final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  static bool _isInitialized = false;

  // Khởi tạo và xin quyền
  static Future<void> init() async {
    if (!_isInitialized) {
      // Xin quyền micro
      final micPermission = await Permission.microphone.request();
      if (micPermission != PermissionStatus.granted) {
        throw Exception("Microphone permission not granted");
      }

      await _recorder.openRecorder();
      _isInitialized = true;
    }
  }

  static Future<String?> startRecording() async {
    try {
      await init();

      final dir = await getTemporaryDirectory();
      final path = "${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a";

      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.aacMP4,
      );

      return path;
    } catch (e) {
      print("${AppStyles.failureIcon} Error starting recorder: $e");
      return null;
    }
  }

  static Future<String?> stopRecording() async {
    try {
      return await _recorder.stopRecorder();
    } catch (e) {
      print("${AppStyles.failureIcon} Error stopping recorder: $e");
      return null;
    }
  }

  static Future<void> dispose() async {
    try {
      await _recorder.closeRecorder();
      _isInitialized = false;
    } catch (e) {
      print("${AppStyles.failureIcon} Error disposing recorder: $e");
    }
  }
}
