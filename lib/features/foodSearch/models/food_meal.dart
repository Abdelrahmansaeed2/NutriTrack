class FoodModel {
  FoodModel(
      {required this.id,
      required this.name,
      this.brand,
      this.servingSize,
      required this.calories,
      required this.macros,
      this.tags = const []});
  final String id;
  final String name;
  String? brand;
  String? servingSize;
  final double calories;
  final FoodMacros macros;
  final List<String> tags;

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        id: json['id'],
        name: json['name'],
        brand: json['brand'],
        servingSize: json['servingSize'],
        calories: (json['calories'] as num).toDouble(),
        macros: FoodMacros.fromJson(json['macros']),
        tags: List<String>.from(json['tags'] ?? []),
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'brand': brand,
        'servingSize': servingSize,
        'calories': calories,
        'macros': macros.toJson(),
        'tags': tags,
      };
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

  factory FoodMacros.fromJson(Map<String, dynamic> json) => FoodMacros(
        protein: (json['protein'] as num).toDouble(),
        carbs: (json['carbs'] as num).toDouble(),
        fat: (json['fat'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      };
}
