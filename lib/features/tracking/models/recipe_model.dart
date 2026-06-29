class Recipe {
  final String id;
  final String name;
  final RecipeTotals totals;
  final List<RecipeIngredientItem> ingredients;

  const Recipe({
    required this.id,
    required this.name,
    required this.totals,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      totals: RecipeTotals.fromJson(
          json['totals'] as Map<String, dynamic>? ?? {}),
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) =>
                  RecipeIngredientItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'totals': totals.toJson(),
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
      };
}

class RecipeTotals {
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  const RecipeTotals({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory RecipeTotals.fromJson(Map<String, dynamic> json) {
    return RecipeTotals(
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toInt() ?? 0,
      carbs: (json['carbs'] as num?)?.toInt() ?? 0,
      fat: (json['fat'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      };
}

class RecipeIngredientItem {
  final String name;
  final String quantity;
  final int calories;

  const RecipeIngredientItem({
    required this.name,
    required this.quantity,
    required this.calories,
  });

  factory RecipeIngredientItem.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientItem(
      name: json['name'] as String? ?? '',
      quantity: json['quantity'] as String? ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'calories': calories,
      };
}
