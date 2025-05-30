import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:olachat_mobile/utils/app_styles.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import '../ui/views/full_image_view.dart';
import '../ui/views/video_player_screen.dart';

class FileOpenerService {
  static Future<void> openMedia(BuildContext context, String url) async {
    final mimeType = lookupMimeType(url) ?? '';
    final isImage = mimeType.startsWith('image/');
    final isVideo = mimeType.startsWith('video/');

    if (isImage) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => FullImageView(imageUrl: url),
      ));
    } else if (isVideo) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(videoUrl: url),
      ));
    } else {
      try {
        final tempDir = await getTemporaryDirectory();
        final fileName = url.split('/').last;
        final savePath = '${tempDir.path}/$fileName';
        await Dio().download(url, savePath);
        await OpenFilex.open(savePath);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${AppStyles.failureIcon} Không thể mở file này")),
        );
      }
    }
  }
}
