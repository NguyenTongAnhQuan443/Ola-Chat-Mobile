import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:olachat_mobile/config/api_config.dart';
import 'package:olachat_mobile/models/friend_request_model.dart';
import 'package:olachat_mobile/services/token_service.dart';
import 'dio_client.dart';

class FriendRequestService {
  final Dio _dio = DioClient().dio;

  // Gửi lời mời kết bạn
  Future<bool> sendFriendRequest(FriendRequestModel request) async {
    final url = ApiConfig.sendFriendRequest;
    final data = request.toJson();
    final token = await TokenService.getAccessToken();
    try {
      print("[SEND] POST $url");
      print("[SEND] Body: ${jsonEncode(data)}");

      final response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("[SEND] Status Code: ${response.statusCode}");
      print("[SEND] Response: ${response.data}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("[SEND] Error: $e");
      return false;
    }
  }

  // Huỷ lời mời kết bạn
  Future<bool> cancelFriendRequest(String receiverId) async {
    final url = ApiConfig.cancelFriendRequest(receiverId);
    final token = await TokenService.getAccessToken();
    try {
      print("[CANCEL] DELETE $url");

      final response = await _dio.delete(
        url,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("[CANCEL] Status Code: ${response.statusCode}");
      print("[CANCEL] Response: ${response.data}");

      return response.statusCode == 200;
    } catch (e) {
      if (e is DioException) {
        print("[CANCEL] DioException: ${e.message}");
        print("[CANCEL] Response: ${e.response?.data}");
        print("[CANCEL] Status Code: ${e.response?.statusCode}");
      } else {
        print("[CANCEL] Unknown error: $e");
      }
      return false;
    }
  }

  // Lấy danh sách đã gửi
  Future<Set<String>> fetchSentRequests() async {
    final url = ApiConfig.getSentFriendRequests;
    final token = await TokenService.getAccessToken();
    try {
      print("[FETCH SENT] GET $url");

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("[FETCH SENT] Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = response.data['data'];
        print("[FETCH SENT] Data: $data");

        return Set<String>.from(data.map((e) => e['userId'].toString()));
      }
    } catch (e) {
      print("[FETCH SENT] Error: $e");
    }
    return {};
  }

  // Lấy danh sách đã nhận
  Future<List<Map<String, String>>> fetchReceivedRequests() async {
    final url = ApiConfig.getReceivedFriendRequests;
    final token = await TokenService.getAccessToken();
    try {
      print("[FETCH RECEIVED] GET $url");

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("[FETCH RECEIVED] Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        print("[FETCH RECEIVED] Data: $data");

        return data.map<Map<String, String>>((item) => {
          'userId': item['userId']?.toString() ?? '',
          'requestId': item['requestId']?.toString() ?? '',
          'displayName': item['displayName']?.toString() ?? 'Ẩn danh',
        }).toList();
      }
    } catch (e) {
      print("[FETCH RECEIVED] Error: $e");
    }
    return [];
  }

  // Chấp nhận lời mời
  Future<bool> acceptRequest(String requestId) async {
    final url = ApiConfig.acceptFriendRequest(requestId);
    final token = await TokenService.getAccessToken();
    try {
      print("[ACCEPT] PUT $url");

      final response = await _dio.put(
        url,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("[ACCEPT] Status Code: ${response.statusCode}");
      print("[ACCEPT] Response: ${response.data}");

      return response.statusCode == 200;
    } catch (e) {
      print("[ACCEPT] Error: $e");
      return false;
    }
  }

  // Từ chối lời mời
  Future<bool> rejectRequest(String requestId) async {
    final url = ApiConfig.rejectFriendRequest(requestId);
    final token = await TokenService.getAccessToken();
    try {
      print("[REJECT] PUT $url");

      final response = await _dio.put(
        url,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("[REJECT] Status Code: ${response.statusCode}");
      print("[REJECT] Response: ${response.data}");

      return response.statusCode == 200;
    } catch (e) {
      print("[REJECT] Error: $e");
      return false;
    }
  }
}
