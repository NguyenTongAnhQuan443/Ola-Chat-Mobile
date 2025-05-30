import 'package:flutter/material.dart';
import 'package:olachat_mobile/models/post_model.dart';
import 'package:olachat_mobile/services/dio_client.dart';
import 'package:olachat_mobile/config/api_config.dart';

class FeedViewModel extends ChangeNotifier {
  List<PostModel> _posts = [];
  bool _isLoading = false;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final dio = DioClient().dio;
      final response = await dio.get(ApiConfig.feedPosts);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        _posts = data.map((e) => PostModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("\u26a0\ufe0f Lỗi khi lấy feed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}