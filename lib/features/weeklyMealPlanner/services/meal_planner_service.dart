import 'package:dio/dio.dart';
import 'package:nutri_track/features/weeklyMealPlanner/models/plan_meal_model.dart';
import 'package:nutri_track/features/weeklyMealPlanner/models/weekly_plan_model.dart';

class MealPlannerService {
  final Dio _dio;

  MealPlannerService(this._dio);

  Future<WeeklyPlan> getLatestWeeklyPlan() async {
    final response = await _dio.get("/api/ai/weekly-plan");
    return WeeklyPlan.fromJson(response.data);
  }

  Future<WeeklyPlan> getWeeklyPlanById(String id) async {
    final response = await _dio.get('/api/ai/weekly-plan/$id');
    return WeeklyPlan.fromJson(response.data['plan']);
  }

  Future<WeeklyPlan> generateWeeklyPlan(String startDate) async {
    final response = await _dio.post(
      '/api/ai/generate-weekly-plan',
      data: {'startDate': startDate},
    );
      print('generateWeeklyPlan response: ${response.data}');
    return WeeklyPlan.fromJson(response.data['plan']);
  }

   Future<PlanMeal> swapMeal({
    required String planId,
    required String date,
    required String mealType,
  }) async {
    final response = await _dio.post(
      '/api/ai/swap-meal',
      data: {
        'planId': planId,
        'date': date,
        'mealType': mealType,
      },
    );
    return PlanMeal.fromJson(response.data['swappedMeal']);
  }

 
}