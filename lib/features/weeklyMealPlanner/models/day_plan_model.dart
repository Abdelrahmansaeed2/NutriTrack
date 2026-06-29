import 'package:nutri_track/features/weeklyMealPlanner/models/plan_meal_model.dart';

class DayPlan {
  final List<PlanMeal> breakfast;
  final List<PlanMeal> lunch;
  final List<PlanMeal> dinner;
  final List<PlanMeal> snacks;

  const DayPlan({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snacks,
  });

  double get totalCalories =>
    breakfast.fold(0.0, (sum, m) => sum + m.calories) +
    lunch.fold(0.0, (sum, m) => sum + m.calories) +
    dinner.fold(0.0, (sum, m) => sum + m.calories) +
    snacks.fold(0.0, (sum, m) => sum + m.calories);

  double get totalProtein =>
    breakfast.fold(0.0, (sum, m) => sum + m.protein) +
    lunch.fold(0.0, (sum, m) => sum + m.protein) +
    dinner.fold(0.0, (sum, m) => sum + m.protein) +
    snacks.fold(0.0, (sum, m) => sum + m.protein);

  double get totalCarbs =>
    breakfast.fold(0.0, (sum, m) => sum + m.carbs) +
    lunch.fold(0.0, (sum, m) => sum + m.carbs) +
    dinner.fold(0.0, (sum, m) => sum + m.carbs) +
    snacks.fold(0.0, (sum, m) => sum + m.carbs);

  double get totalFat =>
    breakfast.fold(0.0, (sum, m) => sum + m.fat) +
    lunch.fold(0.0, (sum, m) => sum + m.fat) +
    dinner.fold(0.0, (sum, m) => sum + m.fat) +
    snacks.fold(0.0, (sum, m) => sum + m.fat);

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    final meals = json['meals'] as Map<String, dynamic>? ?? {};
    return DayPlan(
      breakfast: (meals['breakfast'] as List? ?? [])
          .map((e) => PlanMeal.fromJson(e))
          .toList(),
      lunch: (meals['lunch'] as List? ?? [])
          .map((e) => PlanMeal.fromJson(e))
          .toList(),
      dinner: (meals['dinner'] as List? ?? [])
          .map((e) => PlanMeal.fromJson(e))
          .toList(),
      snacks: (meals['snacks'] as List? ?? [])
          .map((e) => PlanMeal.fromJson(e))
          .toList(),
    );
  }
}