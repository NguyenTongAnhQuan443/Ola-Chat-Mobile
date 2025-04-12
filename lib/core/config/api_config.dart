class ApiConfig {
  static const String host = "http://10.0.2.2:8080";
  // static const String host = "http://silenthero.xyz";
  static const String base = "$host/ola-chat";

  // OTP
  static const String otpSend = "$base/twilio/send-otp";
  static const String otpVerify = "$base/twilio/verify-otp";

  // Auth
  static const String authLoginPhone = "$base/auth/login";
  static const String authLoginGoogle = "$base/auth/login/google";
  static const String authLoginFacebook = "$base/auth/login/facebook";
  static const String authLogout = "$base/auth/logout";
  static const String authRegister = "$base/users";
  static const String authForgotPassword = "$base/auth/forgot-password";
  static const String authResetPassword = "$base/auth/reset-password";
  static const String authRefresh = "$base/auth/refresh";
  static const String authIntrospect = "$base/auth/introspect";

  //   User
  static const String userInfo = "$base/users/my-info";
  static const String updateAvatar = "$base/users/my-avatar";
  static const String updateProfile = "$base/users/my-update";
  static const String changePassword = "$base/users/change-password";


}
