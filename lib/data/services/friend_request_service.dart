import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/utils/config/api_config.dart';
import '../models/friend_request_dto.dart';

class FriendRequestService {
  Future<bool> sendFriendRequest(FriendRequestDTO request) async {
    final response = await http.post(
      Uri.parse(ApiConfig.sendFriendRequest),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    return response.statusCode == 200;
  }
}
