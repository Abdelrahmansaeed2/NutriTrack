import 'package:dio/dio.dart';

class AnalyticsService {
  final Dio _dio;

  AnalyticsService(this._dio);

  Future<Map<String, dynamic>?> getAnalytics() async {
    try {
      final response = await _dio.get('/api/analytics/dashboard');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
