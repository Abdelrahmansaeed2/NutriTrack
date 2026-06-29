import 'package:dio/dio.dart';

class FoodDetailService {
  final Dio _dio;

  FoodDetailService(this._dio);

  Future<bool> logMealItem({
    required String date,
    required String mealType,
    required String foodId,
    required String name,
    required double quantity,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
  }) async {
    try {
      final response = await _dio.post(
        '/api/tracking/daily/$date/meal',
        data: {
          'mealType': mealType.toLowerCase(),
          'item': {
            'foodId': foodId,
            'name': name,
            'quantity': quantity,
            'calories': calories,
            'macros': {
              'protein': protein,
              'carbs': carbs,
              'fat': fat,
            },
          },
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> toggleFavorite(String foodId, bool isFavorite) async {
    try {
      Response response;
      if (isFavorite) {
        response = await _dio.post('/api/food/favorites/$foodId');
      } else {
        response = await _dio.delete('/api/food/favorites/$foodId');
      }
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
