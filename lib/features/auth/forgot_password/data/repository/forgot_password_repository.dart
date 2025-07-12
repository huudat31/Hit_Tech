import 'dart:convert';

import 'package:hit_tech/core/constants/api_endpoint.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordRepository {
  static const Duration _timeout = Duration(seconds: 20);

  Future<ApiResponse> sendOptToEmail(String email) async {
    try {
      final response = await http
          .post(Uri.parse(ApiEndpoint.sendOptToEmail), body: {'email': email})
          .timeout(_timeout);
      final Map<String, dynamic> data = jsonDecode(response.body);
      return ApiResponse.fromJson(data);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse> verifyOtpToResetPassword(String email, String opt) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiEndpoint.verifyOptResetPassword),
            body: {'email': email, 'opt': opt},
          )
          .timeout(ForgotPasswordRepository._timeout);
      final Map<String, dynamic> data = jsonDecode(response.body);
      return ApiResponse.fromJson(data);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse> resetPassword(
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiEndpoint.resetPassword),
            body: {
              'email': email,
              'password': password,
              'confirmPassword': confirmPassword,
            },
          )
          .timeout(_timeout);
      final Map<String, dynamic> data = json.decode(response.body);
      return ApiResponse.fromJson(data);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }
}

class ApiResponse {
  final bool success;
  final String message;
  ApiResponse({required this.success, this.message = ""});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'An error occurred',
    );
  }
}
