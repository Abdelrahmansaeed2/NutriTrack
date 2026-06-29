class WeeklyPlan {
  final String id;
  final String startDate;
  final Map<String, DayPlan> days;

  const WeeklyPlan({
    required this.id,
    required this.startDate,
    required this.days,
  });

  factory WeeklyPlan.fromJson(Map<String, dynamic> json) {
    final daysJson = json['days'] as Map<String, dynamic>? ?? {};
    final days = <String, DayPlan>{};
    for (final entry in daysJson.entries) {
      days[entry.key] =
          DayPlan.fromJson(entry.value as Map<String, dynamic>);
    }
    return WeeklyPlan(
      id: json['id'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      days: days,
    );
  }
}

class DayPlan {
  final Map<String, PlanMeal> meals;

  const DayPlan({required this.meals});

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    final mealsJson = json['meals'] as Map<String, dynamic>? ?? {};
    final meals = <String, PlanMeal>{};
    for (final entry in mealsJson.entries) {
      meals[entry.key] =
          PlanMeal.fromJson(entry.value as Map<String, dynamic>);
    }
    return DayPlan(meals: meals);
  }

  int get totalCalories =>
      meals.values.fold(0, (sum, m) => sum + m.calories);
}

class PlanMeal {
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  const PlanMeal({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory PlanMeal.fromJson(Map<String, dynamic> json) {
    return PlanMeal(
      name: json['name'] as String? ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toInt() ?? 0,
      carbs: (json['carbs'] as num?)?.toInt() ?? 0,
      fat: (json['fat'] as num?)?.toInt() ?? 0,
    );
  }
}
