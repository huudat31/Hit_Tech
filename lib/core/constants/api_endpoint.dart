abstract class ApiEndpoint {
  static const String baseUrl = 'http://192.168.184.103:8080';
  static const String version = '/api/v1';

  // Auth Endpoints
  static const String register = '$baseUrl$version/auth/register';
  static const String verifyOtp = '$baseUrl$version/auth/verify-otp';
  static const String login = '$baseUrl$version/auth/login';
  static const String sendOptToEmail = '$baseUrl$version/auth/forgot-password';
  static const String resetPassword = '$baseUrl$version/auth/reset-password';
  static const String verifyOptResetPassword =
      '$baseUrl$version/auth/verify-opt-to-reset-password';
}
