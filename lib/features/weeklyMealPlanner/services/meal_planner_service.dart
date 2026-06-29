import 'dart:convert';
import 'package:nutri_track/core/networking/api_service.dart'; // Adjust path to your ApiClient
import 'package:nutri_track/features/weeklyMealPlanner/models/plan_meal_model.dart';
import 'package:nutri_track/features/weeklyMealPlanner/models/weekly_plan_model.dart';

class MealPlannerService {
  final ApiClient _apiClient;

  MealPlannerService(this._apiClient);

  Future<WeeklyPlan> getLatestWeeklyPlan() async {
    final response = await _apiClient.get("/api/ai/weekly-plan");
    
    final Map<String, dynamic> decodedData = jsonDecode(response.body);
    return WeeklyPlan.fromJson(decodedData);
  }

  Future<WeeklyPlan> getWeeklyPlanById(String id) async {
    final response = await _apiClient.get('/api/ai/weekly-plan/$id');
    
    final Map<String, dynamic> decodedData = jsonDecode(response.body);
    return WeeklyPlan.fromJson(decodedData['plan']);
  }

  Future<WeeklyPlan> generateWeeklyPlan(String startDate) async {
    final response = await _apiClient.post(
      '/api/ai/generate-weekly-plan',
       {'startDate': startDate},
    );
    

    print("🚨 RAW BACKEND RESPONSE: ${response.body}");    
    
    final Map<String, dynamic> decodedData = jsonDecode(response.body);
    return WeeklyPlan.fromJson(decodedData['plan']);
  }

  Future<PlanMeal> swapMeal({
    required String planId,
    required String date,
    required String mealType,
  }) async {
    final response = await _apiClient.post(
      '/api/ai/swap-meal',
       {
        'planId': planId,
        'date': date,
        'mealType': mealType,
      },
    );
    
    final Map<String, dynamic> decodedData = jsonDecode(response.body);
    return PlanMeal.fromJson(decodedData['swappedMeal']);
  }
}