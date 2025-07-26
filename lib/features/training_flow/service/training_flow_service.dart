import 'package:dio/dio.dart';
import '../model/training_step_model.dart';
import '../config/api_config.dart';
import '../../../services/api/base_api_service.dart';

class TrainingFlowService extends BaseApiService {
  TrainingFlowService({Dio? dio}) : super(dio: dio);

  Future<TrainingStepModel> getTrainingStep({
    required String currentStep,
    required List<String> selectedValue,
    required Map<String, dynamic> selectedValues,
  }) async {
    try {
      if (!await isAuthenticated()) {
        throw Exception('User not authenticated');
      }

      final request = TrainingStepRequest(
        currentStep: currentStep,
        selectedValue: selectedValue,
        selectedValues: selectedValues,
      );

      final response = await dio.post(
        ApiConfig.trainingStepEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return TrainingStepModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get training step data',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Map<String, dynamic>> submitTrainingConfiguration({
    required Map<String, List<String>> userSelections,
  }) async {
    try {
      if (!await isAuthenticated()) {
        throw Exception('User not authenticated');
      }

      final response = await dio.post(
        '/training/submit-configuration',
        data: {
          'user_selections': userSelections,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to submit training configuration');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

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
