import 'dart:io';
import 'package:dio/dio.dart';
import '../model/user_profile_model.dart';
import '../model/setting_request_model.dart' hide ApiResponse;
import '../../../../services/api/base_api_service.dart';

class SettingService extends BaseApiService {
  SettingService({Dio? dio}) : super(dio: dio);

  /// GET /api/v1/user/profile - Lấy thông tin profile user
  Future<UserProfileModel> getUserProfile() async {
    try {
      // Check authentication before making request
      if (!await isAuthenticated()) {
        throw Exception('User not authenticated');
      }

      final response = await dio.get('/api/v1/user/profile');

      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get user profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// PUT /api/v1/user/update-profile - Cập nhật profile user
  Future<ApiResponse<UserProfileModel>> updateProfile({
    required UpdateProfileRequest request,
  }) async {
    try {
      if (!await isAuthenticated()) {
        throw Exception('User not authenticated');
      }

      final response = await dio.put(
        '/api/v1/user/update-profile',
        data: request.toJson(),
      );

      return handleResponse<UserProfileModel>(
        response,
        (data) => UserProfileModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// POST /api/v1/user/upload-avatar - Tải lên ảnh đại diện
  Future<ApiResponse<String>> uploadAvatar({required File avatarFile}) async {
    try {
      if (!await isAuthenticated()) {
        throw Exception('User not authenticated');
      }

      // Create FormData for file upload
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          avatarFile.path,
          filename: avatarFile.path.split('/').last,
        ),
      });

      final response = await dio.post(
        '/api/v1/user/upload-avatar',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return handleStringResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// POST /api/v1/user/personal-information - Điền thông tin cá nhân
  Future<ApiResponse<String>> updatePersonalInformation({
    required PersonalInformationRequest request,
  }) async {
    try {
      if (!await isAuthenticated()) {
        throw Exception('User not authenticated');
      }

      final response = await dio.post(
        '/api/v1/user/personal-information',
        data: request.toJson(),
      );

      return handleStringResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// DELETE /api/v1/user/delete-my-account - Xóa tài khoản
  Future<ApiResponse<String>> deleteMyAccount() async {
    try {
      if (!await isAuthenticated()) {
        throw Exception('User not authenticated');
      }

      final response = await dio.delete('/api/v1/user/delete-my-account');

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
