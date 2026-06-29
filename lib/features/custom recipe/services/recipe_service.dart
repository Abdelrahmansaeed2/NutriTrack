import 'package:dio/dio.dart';
import '../models/custom_recipe_models.dart';

class RecipeService {
  final Dio _dio;

  RecipeService(this._dio);

  Future<bool> createRecipe({
    required String name,
    required List<RecipeIngredient> ingredients,
    required RecipeMacros macros,
  }) async {
    try {
      final response = await _dio.post(
        '/api/recipes',
        data: {
          'name': name,
          'totals': {
            'calories': macros.totalKcal.toDouble(),
            'protein': macros.protein,
            'carbs': macros.carbs,
            'fat': macros.fat,
          },
          'ingredients': ingredients.map((i) => {
            'name': i.name,
            'quantity': i.quantity,
            'calories': i.kcal.toDouble(),
          }).toList(),
        },
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logRecipeAsMeal({
    required String date,
    required String mealType,
    required String name,
    required RecipeMacros macros,
  }) async {
    try {
      final response = await _dio.post(
        '/api/tracking/daily/$date/meal',
        data: {
          'mealType': mealType.toLowerCase(),
          'item': {
            'foodId': 'custom_recipe_${DateTime.now().millisecondsSinceEpoch}',
            'name': name,
            'quantity': 1.0, 
            'calories': macros.totalKcal.toDouble(),
            'macros': {
              'protein': macros.protein,
              'carbs': macros.carbs,
              'fat': macros.fat,
            },
          },
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
