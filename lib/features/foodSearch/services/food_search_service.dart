
import 'package:dio/dio.dart';
import 'package:nutri_track/features/foodSearch/models/food_meal.dart';

class FoodSearchService {
  final Dio _dio;

  FoodSearchService(this._dio);

  Future<List<FoodModel>> searchFoods({
    required String query,
    String? tag
  }) async {
    final response = await _dio.get("/api/foods/search",
    queryParameters: {
      "query": query,
      if(tag != null && tag!="all") "tag" : tag,
    });

    return (response.data as List).map((e) => FoodModel.fromJson(e)).toList();

  }

  Future<List<FoodModel>> getFavourites() async {
    final response = await _dio.get("/api/foods/favourites");
    return (response.data as List).map((e) => FoodModel.fromJson(e)).toList();
  }


  

  Future<void> addToFavourites(String id) async {
    await _dio.post("/api/foods/favourites/$id");
  }

  Future<void> removeFromFavourites(String id) async {
     await _dio.delete("/api/foods/favourites/$id");
  }

  Future<FoodModel> createCustomFood({
    required String name,
    required double calories,
    required FoodMacros macros,
    String? brand,
    String? servingSize,
  }) async {
    final response = await _dio.post(
      '/api/foods/custom',
      data: {
        'name': name,
        'calories': calories,
        'macros': macros.toJson(),
        if (brand != null) 'brand': brand,
        if (servingSize != null) 'servingSize': servingSize,
      },
    );
    return FoodModel.fromJson(response.data);
  }


}