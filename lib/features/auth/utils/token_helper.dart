import 'package:dio/dio.dart';
import 'package:hit_tech/services/shared_preferences/shared_preferences.dart';
import 'package:hit_tech/features/auth/models/repositories/auth_repository.dart';

// Example: How to get and use token
class TokenHelper {
  // Method 1: Lấy token trực tiếp từ SharedPreferences
  static Future<String?> getToken() async {
    return await SharedPreferencesService.getToken();
  }

  // Method 2: Lấy token từ AuthRepository
  static Future<String?> getTokenFromRepository() async {
    final authRepo = AuthRepository();
    return await authRepo.getCurrentToken();
  }

  // Method 3: Check token và thực hiện action
  static Future<void> executeWithToken(Function(String token) action) async {
    final token = await getToken();

    if (token != null && token.isNotEmpty) {
      await action(token);
    } else {
      print('No token available, user needs to login');
      // Navigate to login screen
    }
  }

  // Method 4: Validate token format
  static bool isValidTokenFormat(String? token) {
    if (token == null || token.isEmpty) return false;

    // Add your token validation logic here
    // Example: JWT token should have 3 parts separated by dots
    return token.split('.').length == 3;
  }

  // Method 5: Use token for manual API call
  static Future<void> makeAuthenticatedRequest() async {
    final token = await getToken();

    if (token != null) {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      try {
        final response = await dio.get('https://api.example.com/protected');
        print('Response: ${response.data}');
      } catch (e) {
        print('API call failed: $e');
      }
    }
  }
}

// Usage examples:
void exampleUsage() async {
  // Example 1: Simple token retrieval
  String? token = await TokenHelper.getToken();
  if (token != null) {
    print('Current token: $token');
  }

  // Example 2: Execute action with token
  await TokenHelper.executeWithToken((token) async {
    print('Executing action with token: $token');
    // Your authenticated action here
  });

  // Example 3: In a widget
  // BlocBuilder<AuthBloc, AuthState>(
  //   builder: (context, state) {
  //     if (state is AuthSuccess) {
  //       final token = state.token;
  //       return Text('Logged in with token: ${token?.substring(0, 10)}...');
  //     }
  //     return Text('Not logged in');
  //   },
  // );
}
