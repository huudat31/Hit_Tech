import 'package:dio/dio.dart';
import '../model/training_step_model.dart';
import '../config/api_config.dart';

class TrainingFlowService {
  final Dio _dio;

  TrainingFlowService({Dio? dio}) : _dio = dio ?? Dio() {
    _setupDio();
  }

  void _setupDio() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = ApiConfig.connectionTimeout;
    _dio.options.receiveTimeout = ApiConfig.receiveTimeout;
    _dio.options.headers = ApiConfig.defaultHeaders;
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => print(object),
      ),
    );
  }

  /// Get training step data from API
  ///
  /// Parameters:
  /// - currentStep: Current step being processed (e.g., 'goals', 'type', 'frequency')
  /// - selectedValue: Values selected by user in the current step
  /// - selectedValues: All previous selections from earlier steps
  ///
  /// API Response should contain:
  /// - nextStep: The next step to display (e.g., 'type' after 'goals')
  /// - availableOptions: Options for the next step based on previous selections
  /// - availableSections: All sections returned by API (có thể nhiều phần)
  /// - primarySection: Section chính cần hiển thị
  /// - secondarySection: Section phụ cần hiển thị (optional)
  Future<TrainingStepModel> getTrainingStep({
    required String currentStep,
    required List<String> selectedValue,
    required Map<String, dynamic> selectedValues,
  }) async {
    try {
      final request = TrainingStepRequest(
        currentStep: currentStep,
        selectedValue: selectedValue,
        selectedValues: selectedValues,
      );

      final response = await _dio.post(
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
      final response = await _dio.post(
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
