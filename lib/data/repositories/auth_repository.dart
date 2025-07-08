import 'package:hit_tech/core/constants/app_string.dart';
import 'package:hit_tech/data/models/verify_opt_request.dart';
import 'package:hit_tech/data/models/verify_opt_response.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/register_request.dart';
import '../models/register_response.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthRepository {
  static const String _baseUrl = 'http://192.168.184.103:8080/api/v1/auth';
  static const Duration _timeout = Duration(seconds: 30);

  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Register a new user
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/register'),
            headers: _defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .timeout(_timeout);

      return _handleRegisterResponse(response);
    } on SocketException {
      return RegisterResponse(
        success: false,
        message: AppStrings.noInternetConnection,
      );
    } on HttpException {
      return RegisterResponse(success: false, message: AppStrings.serverError);
    } on FormatException {
      return RegisterResponse(
        success: false,
        message: AppStrings.invalidResponse,
      );
    } catch (e) {
      return RegisterResponse(success: false, message: AppStrings.generalError);
    }
  }

  /// Login user
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/login'),
            headers: _defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .timeout(_timeout);

      return _handleLoginResponse(response);
    } on SocketException {
      return LoginResponse(
        success: false,
        message: AppStrings.noInternetConnection,
      );
    } on HttpException {
      return LoginResponse(success: false, message: AppStrings.serverError);
    } on FormatException {
      return LoginResponse(success: false, message: AppStrings.invalidResponse);
    } catch (e) {
      return LoginResponse(success: false, message: AppStrings.generalError);
    }
  }

  /// Verify OTP
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/verify-otp'),
            headers: _defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .timeout(_timeout);

      return _handleVerifyOtpResponse(response);
    } on SocketException {
      return VerifyOtpResponse(
        success: false,
        message: AppStrings.noInternetConnection,
      );
    } on HttpException {
      return VerifyOtpResponse(success: false, message: AppStrings.serverError);
    } on FormatException {
      return VerifyOtpResponse(
        success: false,
        message: AppStrings.invalidResponse,
      );
    } catch (e) {
      return VerifyOtpResponse(
        success: false,
        message: AppStrings.generalError,
      );
    }
  }

  /// Forgot password
  Future<ForgotPasswordResponse> forgotPassword(String email) async {
    try {
      final request = ForgotPasswordRequest(email: email);
      final response = await http
          .post(
            Uri.parse('$_baseUrl/forgot-password'),
            headers: _defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .timeout(_timeout);

      return _handleForgotPasswordResponse(response);
    } on SocketException {
      return ForgotPasswordResponse(
        success: false,
        message: AppStrings.noInternetConnection,
      );
    } on HttpException {
      return ForgotPasswordResponse(
        success: false,
        message: AppStrings.serverError,
      );
    } on FormatException {
      return ForgotPasswordResponse(
        success: false,
        message: AppStrings.invalidResponse,
      );
    } catch (e) {
      return ForgotPasswordResponse(
        success: false,
        message: AppStrings.generalError,
      );
    }
  }

  // Private methods for handling responses
  RegisterResponse _handleRegisterResponse(http.Response response) {
    final responseData = _parseResponse(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RegisterResponse(
        success: true,
        message: responseData['message'] ?? AppStrings.registerSuccess,
      );
    } else {
      return RegisterResponse(
        success: false,
        message:
            responseData['message'] ?? _getErrorMessage(response.statusCode),
      );
    }
  }

  LoginResponse _handleLoginResponse(http.Response response) {
    final responseData = _parseResponse(response);

    if (response.statusCode == 200) {
      return LoginResponse(
        success: true,
        token: responseData['token'],
        user: responseData['user'],
        message: responseData['message'] ?? AppStrings.loginSuccess,
      );
    } else {
      return LoginResponse(
        success: false,
        message:
            responseData['message'] ?? _getErrorMessage(response.statusCode),
      );
    }
  }

  VerifyOtpResponse _handleVerifyOtpResponse(http.Response response) {
    final responseData = _parseResponse(response);

    if (response.statusCode == 200) {
      return VerifyOtpResponse.fromJson(responseData);
    } else {
      return VerifyOtpResponse(
        success: false,
        message:
            responseData['message'] ?? _getErrorMessage(response.statusCode),
      );
    }
  }

  ForgotPasswordResponse _handleForgotPasswordResponse(http.Response response) {
    final responseData = _parseResponse(response);

    if (response.statusCode == 200) {
      return ForgotPasswordResponse(
        success: true,
        message: responseData['message'] ?? AppStrings.forgotPasswordSuccess,
      );
    } else {
      return ForgotPasswordResponse(
        success: false,
        message:
            responseData['message'] ?? _getErrorMessage(response.statusCode),
      );
    }
  }

  Map<String, dynamic> _parseResponse(http.Response response) {
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  String _getErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return AppStrings.badRequest;
      case 401:
        return AppStrings.unauthorized;
      case 403:
        return AppStrings.forbidden;
      case 404:
        return AppStrings.notFound;
      case 422:
        return AppStrings.validationError;
      case 500:
        return AppStrings.serverError;
      default:
        return AppStrings.generalError;
    }
  }
}

// Model classes for forgot password
class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}

class ForgotPasswordResponse {
  final bool success;
  final String message;

  ForgotPasswordResponse({required this.success, required this.message});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
