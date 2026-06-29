class PlanMeal {
  PlanMeal({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  factory PlanMeal.fromJson(Map<String, dynamic> json) {
    final macros = json['macros'] as Map<String, dynamic>?;
    return PlanMeal(
      name: json['name'] ?? '',
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (macros?['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (macros?['carbs'] as num?)?.toDouble() ?? 0.0,
      fat: (macros?['fat'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }
}