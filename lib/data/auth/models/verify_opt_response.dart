class VerifyOtpResponse {
  final bool success;
  final String? message;
  final String? token;
  final Map<String, dynamic>? user;

  VerifyOtpResponse({
    required this.success,
    this.message,
    this.token,
    this.user,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: true,
      message: json['message'],
      token: json['token'],
      user: json['user'],
    );
  }
}
