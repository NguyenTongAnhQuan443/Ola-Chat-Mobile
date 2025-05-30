import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/models/friend_request_model.dart';
import 'dio_client.dart';

class FriendRequestService {
  final Dio _dio = DioClient().dio;

  // Gửi lời mời kết bạn
  Future<bool> sendFriendRequest(FriendRequestModel request) async {
    try {
      print("[SEND] Sending request: ${request.toJson()}");

      final response = await _dio.post(
        ApiConfig.sendFriendRequest,
        data: request.toJson(), // ✅ để Dio tự mã hoá JSON

        options: Options(
          headers: {
            'Content-Type': 'application/json', // vẫn giữ vì DioClient có set rồi
          },
        ),
      );
      print(jsonEncode(request.toJson())); // kiểm tra xem có đúng JSON không

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("[FriendRequestService] sendFriendRequest error: $e");
      return false;
    }
  }


  // Huỷ lời mời kết bạn
  Future<bool> cancelFriendRequest(String receiverId) async {
    try {
      final response = await _dio.delete(
        ApiConfig.cancelFriendRequest(receiverId),
        options: Options(contentType: Headers.jsonContentType),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("[FriendRequestService] cancelFriendRequest error: $e");
      return false;
    }
  }

  // Lấy danh sách đã gửi
  Future<Set<String>> fetchSentRequests() async {
    try {
      final response = await _dio.get(ApiConfig.getSentFriendRequests);
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return Set<String>.from(data.map((e) => e['userId'].toString()));
      }
    } catch (e) {
      print("[FriendRequestService] fetchSentRequests error: $e");
    }
    return {};
  }

  // Lấy danh sách đã nhận
  Future<List<Map<String, String>>> fetchReceivedRequests() async {
    try {
      final response = await _dio.get(ApiConfig.getReceivedFriendRequests);
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data
            .map<Map<String, String>>((item) => {
                  'userId': item['userId']?.toString() ?? '',
                  'requestId': item['requestId']?.toString() ?? '',
                  'displayName': item['displayName']?.toString() ?? 'Ẩn danh',
                })
            .toList();
      }
    } catch (e) {
      print("[FriendRequestService] fetchReceivedRequests error: $e");
    }
    return [];
  }

  // Chấp nhận
  Future<bool> acceptRequest(String requestId) async {
    try {
      final response = await _dio.put(
        ApiConfig.acceptFriendRequest(requestId),
        options: Options(contentType: Headers.jsonContentType),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("[FriendRequestService] acceptRequest error: $e");
      return false;
    }
  }

  // Từ chối
  Future<bool> rejectRequest(String requestId) async {
    try {
      final response = await _dio.put(
        ApiConfig.rejectFriendRequest(requestId),
        options: Options(contentType: Headers.jsonContentType),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("[FriendRequestService] rejectRequest error: $e");
      return false;
    }
  }
}
