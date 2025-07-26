import 'package:hit_tech/core/constants/api_endpoint.dart';

class ApiConfig {
  static const String baseUrl = ApiEndpoint.baseUrl;
  static const String trainingStepEndpoint = '/training-step';
  static const String saveTrainingPlanEndpoint = '/training-plan';
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
