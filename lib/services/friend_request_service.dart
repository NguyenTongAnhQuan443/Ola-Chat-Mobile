import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';
import '../models/friend_request_model.dart';
import 'dio_client.dart';

class FriendRequestService {
  final Dio _dio = DioClient().dio;

  // Gửi lời mời kết bạn
  Future<bool> sendFriendRequest(FriendRequestModel request) async {
    final response = await _dio.post(
      ApiConfig.sendFriendRequest,
      data: request.toJson(),
      options: Options(contentType: "application/json"),
    );
    return response.statusCode == 200;
  }

  // Huỷ lời mời kết bạn
  Future<bool> cancelFriendRequest(String receiverId) async {
    final response = await _dio.delete(
      ApiConfig.cancelFriendRequest(receiverId),
      options: Options(contentType: "application/json"),
    );
    return response.statusCode == 200;
  }

  // Nhận danh sách đã gửi
  Future<Set<String>> fetchSentRequests() async {
    final response = await _dio.get(ApiConfig.getSentFriendRequests);
    if (response.statusCode == 200) {
      final data = response.data['data'];
      return Set<String>.from(data.map((item) => item['userId'].toString()));
    }
    return {};
  }

  // Nhận danh sách đã nhận
  Future<List<Map<String, String>>> fetchReceivedRequests() async {
    final response = await _dio.get(ApiConfig.getReceivedFriendRequests);
    if (response.statusCode == 200) {
      final data = response.data['data'] as List;
      return data.map<Map<String, String>>((item) => {
        'userId': item['userId']?.toString() ?? '',
        'requestId': item['requestId']?.toString() ?? '',
        'displayName': item['displayName']?.toString() ?? 'Ẩn danh',
      }).toList();
    }
    return [];
  }

  // Chấp nhận lời mời kết bạn
  Future<bool> acceptRequest(String requestId) async {
    final response = await _dio.put(
      ApiConfig.acceptFriendRequest(requestId),
      options: Options(contentType: "application/json"),
    );
    return response.statusCode == 200;
  }

  // Tuỳ chối lời mời kết bạn
  Future<bool> rejectRequest(String requestId) async {
    final response = await _dio.put(
      ApiConfig.rejectFriendRequest(requestId),
      options: Options(contentType: "application/json"),
    );
    return response.statusCode == 200;
  }
}
