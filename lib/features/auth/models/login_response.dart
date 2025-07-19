class LoginResponse {
  final bool success;
  final String? message;
  final String? token;
  final Map<String, dynamic>? user;

  LoginResponse({required this.success, this.message, this.token, this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'],
      token: json['token'],
      user: json['user'],
    );
  }
}
