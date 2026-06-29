class FoodItem {
  final String id;
  final String name;
  final String brand;
  final String servingSize;
  final int calories;
  final FoodMacros macros;
  final List<String> tags;

  const FoodItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.servingSize,
    required this.calories,
    required this.macros,
    this.tags = const [],
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      servingSize: json['servingSize'] as String? ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      macros: FoodMacros.fromJson(
          json['macros'] as Map<String, dynamic>? ?? {}),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class FoodMacros {
  final double protein;
  final double carbs;
  final double fat;

  const FoodMacros({
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory FoodMacros.fromJson(Map<String, dynamic> json) {
    return FoodMacros(
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
