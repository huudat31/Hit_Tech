import 'package:dio/dio.dart';
import '../../../services/api/base_api_service.dart';

/// Home service với authentication token handling
class HomeService extends BaseApiService {
  HomeService({Dio? dio}) : super(dio: dio);

  /// GET /api/v1/home/dashboard - Lấy thông tin dashboard
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      if (!await isAuthenticated()) {
        throw Exception('User not authenticated');
      }

      final response = await dio.get('/api/v1/home/dashboard');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get dashboard data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// GET /api/v1/home/stats - Lấy thống kê người dùng
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      if (!await isAuthenticated()) {
        throw Exception('User not authenticated');
      }

      final response = await dio.get('/api/v1/home/stats');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get user stats: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// GET /api/v1/home/recent-activities - Lấy hoạt động gần đây
  Future<List<Map<String, dynamic>>> getRecentActivities() async {
    try {
      if (!await isAuthenticated()) {
        throw Exception('User not authenticated');
      }

      final response = await dio.get('/api/v1/home/recent-activities');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        } else if (data is Map && data.containsKey('activities')) {
          return List<Map<String, dynamic>>.from(data['activities']);
        } else {
          return [];
        }
      } else {
        throw Exception(
          'Failed to get recent activities: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// POST /api/v1/home/sync-data - Đồng bộ dữ liệu
  Future<ApiResponse<String>> syncUserData() async {
    try {
      if (!await isAuthenticated()) {
        throw Exception('User not authenticated');
      }

      final userData = await getCurrentUser();
      final response = await dio.post(
        '/api/v1/home/sync-data',
        data: {
          'timestamp': DateTime.now().toIso8601String(),
          'user_data': userData,
        },
      );

      return handleStringResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Helper method to handle Dio errors
  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.sendTimeout:
        return Exception('Send timeout');
      case DioExceptionType.receiveTimeout:
        return Exception('Receive timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Unknown error';
        return Exception('Server error ($statusCode): $message');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.connectionError:
        return Exception('Connection error');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
