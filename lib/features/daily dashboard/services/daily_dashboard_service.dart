import 'package:dio/dio.dart';

class DailyDashboardService {
  final Dio _dio;

  DailyDashboardService(this._dio);

  Future<Map<String, dynamic>?> getDailyLog(String date) async {
    try {
      final response = await _dio.get('/api/tracking/daily/$date');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> removeMealItem(String date, String mealType, int index) async {
    try {
      final response = await _dio.delete(
        '/api/tracking/daily/$date/meal',
        data: {
          'mealType': mealType.toLowerCase(),
          'index': index,
        },
      );
      if (response.statusCode == 200) {
        return response.data['log'] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
