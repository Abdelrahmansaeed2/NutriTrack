class DailyLog {
  final String date;
  final Map<String, List<MealItem>> meals;
  final List<WaterEntry> waterIntake;
  final double? weightKg;
  final String? progressPhotoUrl;

  const DailyLog({
    required this.date,
    required this.meals,
    required this.waterIntake,
    this.weightKg,
    this.progressPhotoUrl,
  });

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    final mealsJson = json['meals'] as Map<String, dynamic>? ?? {};
    final meals = <String, List<MealItem>>{};
    for (final entry in mealsJson.entries) {
      meals[entry.key] = (entry.value as List<dynamic>)
          .map((e) => MealItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return DailyLog(
      date: json['date'] as String? ?? '',
      meals: meals,
      waterIntake: (json['waterIntake'] as List<dynamic>?)
              ?.map((e) => WaterEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      progressPhotoUrl: json['progressPhotoUrl'] as String?,
    );
  }

  /// Total calories for the day across all meals
  int get totalCalories => meals.values
      .expand((list) => list)
      .fold(0, (sum, item) => sum + item.calories);

  /// Total water intake in ml
  int get totalWaterMl =>
      waterIntake.fold(0, (sum, e) => sum + e.amountMl);
}

class MealItem {
  final String foodId;
  final String name;
  final double quantity;
  final int calories;
  final MealMacros macros;

  const MealItem({
    required this.foodId,
    required this.name,
    required this.quantity,
    required this.calories,
    required this.macros,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      foodId: json['foodId']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      macros: MealMacros.fromJson(
          json['macros'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'foodId': foodId,
        'name': name,
        'quantity': quantity,
        'calories': calories,
        'macros': macros.toJson(),
      };
}

class MealMacros {
  final double protein;
  final double carbs;
  final double fat;

  const MealMacros({
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory MealMacros.fromJson(Map<String, dynamic> json) {
    return MealMacros(
      protein: (json['protein'] as num?)?.toDouble() ?? 0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      };
}

class WaterEntry {
  final int amountMl;
  final String type;
  final DateTime timestamp;

  const WaterEntry({
    required this.amountMl,
    required this.type,
    required this.timestamp,
  });

  factory WaterEntry.fromJson(Map<String, dynamic> json) {
    return WaterEntry(
      amountMl: (json['amountMl'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? 'water',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
