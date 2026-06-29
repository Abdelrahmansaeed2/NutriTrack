import '../../../core/network/api_client.dart';
import '../models/daily_log_model.dart';

class TrackingService {
  static TrackingService? _instance;
  static TrackingService get instance {
    _instance ??= TrackingService._();
    return _instance!;
  }
  TrackingService._();

  String _dateStr(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  /// GET /api/tracking/daily/:date
  Future<DailyLog> getDailyLog(DateTime date) async {
    final response = await ApiClient.instance.get('/api/tracking/daily/${_dateStr(date)}');
    return DailyLog.fromJson(response.data as Map<String, dynamic>);
  }

  /// POST /api/tracking/daily/:date/meal
  Future<void> logMeal(DateTime date, String mealType, MealItem item) async {
    await ApiClient.instance.post(
      '/api/tracking/daily/${_dateStr(date)}/meal',
      data: {'mealType': mealType, 'item': item.toJson()},
    );
  }

  /// DELETE /api/tracking/daily/:date/meal
  Future<void> deleteMeal(DateTime date, String mealType, int index) async {
    await ApiClient.instance.delete(
      '/api/tracking/daily/${_dateStr(date)}/meal',
      data: {'mealType': mealType, 'index': index},
    );
  }

  /// POST /api/tracking/daily/:date/water
  Future<void> logWater(DateTime date, int amountMl, {String type = 'water'}) async {
    await ApiClient.instance.post(
      '/api/tracking/daily/${_dateStr(date)}/water',
      data: {'amountMl': amountMl, 'type': type},
    );
  }

  /// DELETE /api/tracking/daily/:date/water
  Future<void> deleteWater(DateTime date, int index) async {
    await ApiClient.instance.delete(
      '/api/tracking/daily/${_dateStr(date)}/water',
      data: {'index': index},
    );
  }

  /// POST /api/tracking/daily/:date/weight
  Future<void> logWeight(DateTime date, double weightKg) async {
    await ApiClient.instance.post(
      '/api/tracking/daily/${_dateStr(date)}/weight',
      data: {'weightKg': weightKg},
    );
  }
}
