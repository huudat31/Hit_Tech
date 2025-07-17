import 'package:hit_tech/core/constants/api_endpoint.dart';
import 'package:hit_tech/core/constants/app_string.dart';
import 'package:hit_tech/features/auth/data/auth/models/reset_password_request.dart';
import 'package:hit_tech/features/auth/data/auth/models/reset_password_response.dart';
import 'package:hit_tech/features/auth/data/auth/models/verify_opt_request.dart';
import 'package:hit_tech/features/auth/data/auth/models/verify_opt_response.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../auth/models/register_request.dart';
import '../auth/models/register_response.dart';
import '../auth/models/login_request.dart';
import '../auth/models/login_response.dart';

class AuthRepository {
  static const Duration _timeout = Duration(seconds: 30);

  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiEndpoint.register),
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

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiEndpoint.login),
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

  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiEndpoint.verifyOtp),
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

  Map<String, dynamic> _parseResponse(http.Response response) {
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  Future<ApiResponse> verifyOptResetPassword(VerifyOtpRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiEndpoint.verifyOptResetPassword),
            headers: _defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .timeout(_timeout);
      return _handleApiResponse(response);
    } on SocketException {
      return ApiResponse(
        success: false,
        message: AppStrings.noInternetConnection,
      );
    } on HttpException {
      return ApiResponse(success: false, message: AppStrings.serverError);
    } on FormatException {
      return ApiResponse(success: false, message: AppStrings.invalidResponse);
    } catch (e) {
      return ApiResponse(success: false, message: AppStrings.generalError);
    }
  }

  Future<ResetPasswordResponse> resetPassword(
    ResetPasswordRequest request,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiEndpoint.resetPassword),
            headers: _defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .timeout(_timeout);

      return _handleResetPasswordResponse(response);
    } on SocketException {
      return ResetPasswordResponse(
        success: false,
        message: AppStrings.noInternetConnection,
      );
    } on HttpException {
      return ResetPasswordResponse(
        success: false,
        message: AppStrings.serverError,
      );
    } on FormatException {
      return ResetPasswordResponse(
        success: false,
        message: AppStrings.invalidResponse,
      );
    } catch (e) {
      return ResetPasswordResponse(
        success: false,
        message: AppStrings.generalError,
      );
    }
  }

  ResetPasswordResponse _handleResetPasswordResponse(http.Response response) {
    final responseData = _parseResponse(response);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ResetPasswordResponse(
        success: true,
        message: responseData['message'] ?? "Đặt lại mật khẩu thành công",
      );
    } else {
      return ResetPasswordResponse(
        success: false,
        message:
            responseData['message'] ?? _getErrorMessage(response.statusCode),
      );
    }
  }

  ApiResponse _handleApiResponse(http.Response response) {
    final responseData = _parseResponse(response);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse(
        success: true,
        message: responseData['message'] ?? AppStrings.forgotPasswordSuccess,
      );
    } else {
      return ApiResponse(
        success: false,
        message:
            responseData['message'] ?? _getErrorMessage(response.statusCode),
      );
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

class ApiResponse {
  final bool success;
  final String message;

  ApiResponse({required this.success, required this.message});
}
