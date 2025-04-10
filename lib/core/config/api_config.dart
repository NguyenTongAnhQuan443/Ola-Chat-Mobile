class ApiConfig {
  static const String host = "http://10.0.2.2:8080";
  static const String base = "$host/ola-chat";

  // OTP
  static const String sendOtp = "$base/twilio/send-otp";
  static const String verifyOtp = "$base/twilio/verify-otp";

  // Auth
  static const String loginPhone = "$base/auth/login";
  static const String loginGoogle = "$base/auth/login/google";
  static const String loginFacebook = "$base/auth/login/facebook";
  static const String register = "$base/auth/register";
  static const String logout = "$base/auth/logout";
}
