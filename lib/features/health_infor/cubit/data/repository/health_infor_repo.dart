import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hit_tech/core/constants/api_endpoint.dart';
import 'package:hit_tech/features/health_infor/model/heath_infor_model.dart';

class HealthInforRepo {
  final Dio _dio;
  
  HealthInforRepo(this._dio);
  Future<bool> submitHealthInfo(HealthInfoModel healthInfo) async {
    try {
      final response = await _dio.post(
        ApiEndpoint.heathInformation,
        data: jsonEncode(healthInfo.toJson()),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error submitting health info: $e');
      return false;
    }
  }
}

class ApiResponse {
  final bool success;
  final String message;
  ApiResponse({required this.success, this.message = ""});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'An error occurred',
    );
  }
}
