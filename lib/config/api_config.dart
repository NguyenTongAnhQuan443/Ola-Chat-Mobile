class ApiConfig {
  static String host = "http://192.168.100.135:8080";
  static String get base => "$host/ola-chat";

  // OTP
  static String get otpSend => "$base/otp/send";
  static String get otpVerify => "$base/otp/verify";

  // Auth
  static String get authLoginPhone => "$base/auth/login";
  static String get authLoginGoogle => "$base/auth/login/google";
  static String get authLoginFacebook => "$base/auth/login/facebook";
  static String get authLogout => "$base/auth/logout";
  static String get authForgotPassword => "$base/auth/forgot-password";
  static String get authResetPassword => "$base/auth/reset-password";
  static String get authRefresh => "$base/auth/refresh";
  static String get authIntrospect => "$base/auth/introspect";

  // User
  static String get userInfo => "$base/users/my-info";
  static String get updateAvatar => "$base/users/my-avatar";
  static String get updateProfile => "$base/users/my-update";
  static String get changePassword => "$base/users/change-password";
  static String get authRegister => "$base/users";
  static String get sendEmailUpdateOtp => "$base/users/update-email";
  static String get verifyEmailUpdateOtp => "$base/users/verify-update-email";
  static String searchUser(String query) => "$base/users/search?query=$query";
  static String get getMyFriends => "$base/users/my-friends";

  static String loginHistory(String userId) =>
      "$base/api/login-history/$userId";
  static String setUserOffline(String userId) =>
      "$base/api/login-history/offline/$userId";
  static String get ping => "$base/api/login-history/ping";

  static String get registerDevice => "$base/api/notifications/register-device";

  // Friend
  static String get sendFriendRequest => "$base/api/friends/send-request";
  static String get getSentFriendRequests => "$base/api/friends/requests/sent";
  static String get getReceivedFriendRequests =>
      "$base/api/friends/requests/received";
  static String cancelFriendRequest(String receiverId) =>
      "$base/api/friends/requests/$receiverId/cancel";
  static String acceptFriendRequest(String requestId) =>
      "$base/api/friends/$requestId/accept";
  static String rejectFriendRequest(String requestId) =>
      "$base/api/friends/$requestId/reject";

  // Notification
  static String getNotifications(
      {required int page, int size = 10, String sort = 'desc'}) {
    return "$base/api/notifications?page=$page&size=$size&sort=$sort";
  }

  // WebSocket URL động
  static String get socketUrl {
    final uri = Uri.parse(host);
    final scheme = uri.scheme == 'https' ? 'wss' : 'ws';
    final wsHost = uri.host;
    final port = uri.hasPort ? ':${uri.port}' : '';
    return "$scheme://$wsHost$port/ola-chat/ws";
  }

  // Conversation
  static String get getConversations => "$base/api/conversations";
  static String getMessagesByConversation(String conversationId) =>
      "$base/api/conversations/$conversationId/messages";
  static String getUsersInConversation(String conversationId) =>
      "$base/api/conversations/$conversationId/users";

  // File
  static String get upFile => "$base/files/upload";

  // Group
  static String updateGroup(String groupId) => "$base/api/groups/$groupId";
  static String get createGroup => "$base/api/groups";
  static String addMembersToGroup(String groupId) => "$base/api/groups/$groupId/add-member";
  static String removeMemberFromGroup(String groupId, String userId) =>
      "$base/api/groups/$groupId/remove/$userId";

}
