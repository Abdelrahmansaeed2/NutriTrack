import '../../../core/network/api_client.dart';
import '../models/weekly_plan_model.dart';

class AiService {
  static AiService? _instance;
  static AiService get instance {
    _instance ??= AiService._();
    return _instance!;
  }
  AiService._();

  String _dateStr(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  /// POST /api/ai/generate-weekly-plan
  Future<WeeklyPlan> generateWeeklyPlan({DateTime? startDate}) async {
    final start = startDate ?? DateTime.now();
    final response = await ApiClient.instance.post(
      '/api/ai/generate-weekly-plan',
      data: {'startDate': _dateStr(start)},
    );
    final body = response.data as Map<String, dynamic>;
    return WeeklyPlan.fromJson(body['plan'] as Map<String, dynamic>);
  }

  /// GET /api/ai/weekly-plan — latest generated plan
  Future<WeeklyPlan?> getLatestWeeklyPlan() async {
    try {
      final response = await ApiClient.instance.get('/api/ai/weekly-plan');
      final body = response.data;
      if (body == null) return null;
      // Backend may return { plan: {...} } or the plan directly
      if (body is Map<String, dynamic>) {
        final planData = body['plan'] ?? body;
        return WeeklyPlan.fromJson(planData as Map<String, dynamic>);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/ai/weekly-plan/:id
  Future<WeeklyPlan> getWeeklyPlanById(String id) async {
    final response = await ApiClient.instance.get('/api/ai/weekly-plan/$id');
    return WeeklyPlan.fromJson(response.data as Map<String, dynamic>);
  }

  /// POST /api/ai/swap-meal
  Future<PlanMeal> swapMeal(String planId, String date, String mealType) async {
    final response = await ApiClient.instance.post(
      '/api/ai/swap-meal',
      data: {'planId': planId, 'date': date, 'mealType': mealType},
    );
    final body = response.data as Map<String, dynamic>;
    return PlanMeal.fromJson(body['swappedMeal'] as Map<String, dynamic>);
  }

  /// POST /api/ai/generate-grocery-list
  Future<void> generateGroceryList(String planId) async {
    await ApiClient.instance.post(
      '/api/ai/generate-grocery-list',
      data: {'planId': planId},
    );
  }

  /// POST /api/ai/recommend-meal
  Future<Map<String, dynamic>> recommendMeal(int remainingCalories, int remainingProtein) async {
    final response = await ApiClient.instance.post(
      '/api/ai/recommend-meal',
      data: {
        'remainingCalories': remainingCalories,
        'remainingProtein': remainingProtein,
      },
    );
    final body = response.data as Map<String, dynamic>;
    return body['suggestion'] as Map<String, dynamic>? ?? {};
  }
}
