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
      print('🍳 createRecipe status: ${response.statusCode}');
      return response.statusCode == 201;
    } catch (e) {
      print('🍳 createRecipe error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> logRecipeAsMeal({
    required String date,
    required String mealType,
    required String name,
    required RecipeMacros macros,
  }) async {
    final body = {
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
    };
    print('📝 logRecipeAsMeal → date=$date mealType=${mealType.toLowerCase()} body=$body');
    try {
      final response = await _dio.post(
        '/api/tracking/daily/$date/meal',
        data: body,
      );
      print('📝 logRecipeAsMeal status: ${response.statusCode} body: ${response.data}');
      if (response.statusCode == 200) {
        // Return the updated log directly from the response
        final log = response.data['log'] as Map<String, dynamic>?;
        return log;
      }
      return null;
    } catch (e) {
      print('📝 logRecipeAsMeal error: $e');
      return null;
    }
  }
}
