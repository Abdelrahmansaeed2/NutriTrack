import 'package:dio/dio.dart';

class WaterTrackingService {
  final Dio _dio;

  WaterTrackingService(this._dio);

  Future<Map<String, dynamic>?> getWaterLog(String date) async {
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

  Future<Map<String, dynamic>?> addWater(String date, int amountMl, String type) async {
    try {
      final response = await _dio.post(
        '/api/tracking/daily/$date/water',
        data: {
          'amountMl': amountMl,
          'type': type,
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

  Future<Map<String, dynamic>?> removeWater(String date, int index) async {
    try {
      final response = await _dio.delete(
        '/api/tracking/daily/$date/water',
        data: {
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
