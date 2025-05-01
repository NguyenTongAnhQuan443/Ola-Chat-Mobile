class ApiConfig {
  // static const String host = "http://10.0.2.2:8080"; // local cho emulator
  // static const String host = "http://silenthero.xyz"; // host thật
  static const String host = "http://192.168.1.4:8080";

  static const String base = "$host/ola-chat";

  // OTP
  static const String otpSend = "$base/otp/send";
  static const String otpVerify = "$base/otp/verify";

  // Auth
  static const String authLoginPhone = "$base/auth/login";
  static const String authLoginGoogle = "$base/auth/login/google";
  static const String authLoginFacebook = "$base/auth/login/facebook";
  static const String authLogout = "$base/auth/logout";
  static const String authForgotPassword = "$base/auth/forgot-password";
  static const String authResetPassword = "$base/auth/reset-password";
  static const String authRefresh = "$base/auth/refresh";
  static const String authIntrospect = "$base/auth/introspect";

  // User
  static const String userInfo = "$base/users/my-info";
  static const String updateAvatar = "$base/users/my-avatar";
  static const String updateProfile = "$base/users/my-update";
  static const String changePassword = "$base/users/change-password";
  static const String authRegister = "$base/users";
  static const String sendEmailUpdateOtp = "$base/users/update-email";
  static const String verifyEmailUpdateOtp = "$base/users/verify-update-email";
  static String searchUser(String query) => "$base/users/search?query=$query";

  static String loginHistory(String userId) => "$base/api/login-history/$userId";
  static String setUserOffline(String userId) =>"$base/api/login-history/offline/$userId";
  static const String ping = "$base/api/login-history/ping";

  static const String registerDevice = "$base/api/notifications/register-device";

  // Friend
  static const String sendFriendRequest = "$base/api/friends/send-request";
  static const String getSentFriendRequests = "$base/api/friends/requests/sent";
  static const String getReceivedFriendRequests = "$base/api/friends/requests/received";
  static String cancelFriendRequest(String receiverId) =>
      "$base/api/friends/requests/$receiverId/cancel";

}
