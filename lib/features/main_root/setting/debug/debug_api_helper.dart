import 'dart:math';
import 'package:dio/dio.dart';
import '../../../../services/shared_preferences/shared_preferences.dart';

class DebugApiHelper {
  static Future<void> testApiConnection() async {
    try {
      print('[DEBUG] Testing API connection...');

      // Test 1: Check token
      final token = await SharedPreferencesService.getToken();
      final hasToken = token != null && token.isNotEmpty;

      print('[DEBUG] Has token: $hasToken');
      if (hasToken) {
        print('[DEBUG] Token preview: ${token.substring(0, 20)}...');
      }

      // Test 2: Test API connection
      final dio = Dio();
      dio.options = BaseOptions(
        baseUrl: 'http://localhost:8000',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      );

      // Add token to headers if available
      if (hasToken) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }

      // Test API call
      final response = await dio.get('/api/v1/user/profile');

      print('[DEBUG] API Response Status: ${response.statusCode}');
      print('[DEBUG] API Response Data: ${response.data}');
    } catch (e) {
      print('[DEBUG] API Error: $e');

      if (e is DioException) {
        print('[DEBUG] DioException type: ${e.type}');
        print('[DEBUG] DioException message: ${e.message}');
        if (e.response != null) {
          print('[DEBUG] Response status: ${e.response?.statusCode}');
          print('[DEBUG] Response data: ${e.response?.data}');
        }
      }
    }
  }

  static Future<void> testTokenOnly() async {
    try {
      final token = await SharedPreferencesService.getToken();
      final isLoggedIn = await SharedPreferencesService.isLoggedIn();
      final userData = await SharedPreferencesService.getUserData();

      print('[DEBUG] ========== TOKEN INFO ==========');
      print('[DEBUG] Is logged in: $isLoggedIn');
      print('[DEBUG] Has token: ${token != null}');
      if (token != null) {
        print('[DEBUG] Token length: ${token.length}');
        print(
          '[DEBUG] Token preview: ${token.substring(0, min(50, token.length))}...',
        );
      }
      print('[DEBUG] User data: $userData');
      print('[DEBUG] ================================');
    } catch (e) {
      print('[DEBUG] Error checking token: $e');
    }
  }
}
