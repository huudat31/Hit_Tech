import 'package:dio/dio.dart';
import '../shared_preferences/shared_preferences.dart';

/// Base service class với authentication token handling
class BaseApiService {
  final Dio _dio;

  BaseApiService({Dio? dio}) : _dio = dio ?? Dio() {
    _setupDio();
  }

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: 'http://localhost:8000', // Updated to match your API server
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add logging interceptor
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('[API] $obj'),
      ),
    );

    // Add authentication interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            // Automatically add token to all requests
            final token = await SharedPreferencesService.getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
              print('[AUTH] Token added to request: ${options.path}');
            } else {
              print('[AUTH] No token found for request: ${options.path}');
            }
          } catch (e) {
            print('[AUTH] Error getting token: $e');
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          print(
            '[API] Error: ${error.response?.statusCode} - ${error.message}',
          );

          // Handle authentication errors
          if (error.response?.statusCode == 401) {
            print('[AUTH] Token expired or invalid, logging out...');
            try {
              await SharedPreferencesService.logout();
              // You might want to emit a global event or navigate to login
              // This depends on your app's navigation structure
            } catch (e) {
              print('[AUTH] Error during logout: $e');
            }
          }
          handler.next(error);
        },
        onResponse: (response, handler) {
          print(
            '[API] Response: ${response.statusCode} - ${response.requestOptions.path}',
          );
          handler.next(response);
        },
      ),
    );
  }

  /// Get the configured Dio instance
  Dio get dio => _dio;

  /// Helper method to check if user is authenticated before making requests
  Future<bool> isAuthenticated() async {
    try {
      return await SharedPreferencesService.isLoggedIn();
    } catch (e) {
      print('[AUTH] Error checking authentication: $e');
      return false;
    }
  }

  /// Helper method to get current user data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      return await SharedPreferencesService.getUserData();
    } catch (e) {
      print('[AUTH] Error getting current user: $e');
      return null;
    }
  }

  /// Generic method for handling API responses
  ApiResponse<T> handleResponse<T>(
    Response response,
    T Function(dynamic data) fromJson,
  ) {
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data != null) {
          return ApiResponse<T>(
            isSuccess: true,
            data: fromJson(data),
            message: 'Success',
          );
        } else {
          return ApiResponse<T>(isSuccess: false, message: 'No data received');
        }
      } else {
        return ApiResponse<T>(
          isSuccess: false,
          message: 'Request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ApiResponse<T>(
        isSuccess: false,
        message: 'Error parsing response: $e',
      );
    }
  }

  /// Generic method for handling simple string responses
  ApiResponse<String> handleStringResponse(Response response) {
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<String>(
          isSuccess: true,
          data: response.data?.toString() ?? 'Success',
          message: 'Success',
        );
      } else {
        return ApiResponse<String>(
          isSuccess: false,
          message: 'Request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ApiResponse<String>(
        isSuccess: false,
        message: 'Error handling response: $e',
      );
    }
  }
}

/// Generic API response wrapper
class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? message;

  const ApiResponse({required this.isSuccess, this.data, this.message});

  @override
  String toString() {
    return 'ApiResponse(isSuccess: $isSuccess, data: $data, message: $message)';
  }
}
