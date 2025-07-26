import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_endpoint.dart';
import '../model/training_flow_request.dart';
import '../model/training_flow_response.dart';

class TrainingFlowService {
  static const String url = ApiEndpoint.flowStep;

  static Future<TrainingFlowResponse> sendStep(
    TrainingFlowRequest request,
  ) async {
    try {
      final token =
          "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ1c2VyMTIzIiwiZXhwIjoxNzUzNTUwMTg1LCJpYXQiOjE3NTM1NDY1ODUsInVzZXJJZCI6ImI0ZmE4MDQzLTUxYjQtNGRmNy1iYjVmLWQwNWZiOTQ5NDIwZCIsImp0aSI6IjczZTkyYWYyLWY1N2MtNGRhNy04ZDZkLTJlOWViYTQ1Y2ZmYyIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJlbWFpbCI6ImJveXpzbm8xQGdtYWlsLmNvbSJ9.GOuFg4bhnGI8rU-JcR4_w7Rgtl3bLZlOGglBb3_DxhniUmpdVTbcmKXJ23gp8LHv9A0hYKeR1aZzVP0xVcSnEg";
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode(request.toJson()),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return TrainingFlowResponse.fromJson(jsonData);
      } else {
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      print('Timeout: Không thể kết nối đến server.');
      rethrow;
    } catch (e, stack) {
      print('EXCEPTION: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }
}
