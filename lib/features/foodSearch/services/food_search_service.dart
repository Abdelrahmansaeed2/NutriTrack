import 'dart:convert';
import 'package:nutri_track/core/networking/api_service.dart'; // Adjust path to your ApiClient
import 'package:nutri_track/features/foodSearch/models/food_meal.dart';

class FoodSearchService {
  final ApiClient _apiClient;

  FoodSearchService(this._apiClient);

  Future<List<FoodModel>> searchFoods({
    required String query,
    String? tag,
  }) async {
    final queryParams = {
      "query": query,
      if (tag != null && tag != "all") "tag": tag,
    };

    final uri = Uri(path: "/api/foods/search", queryParameters: queryParams);

    final response = await _apiClient.get(uri.toString());

    final List decodedData = jsonDecode(response.body);
    return decodedData.map((e) => FoodModel.fromJson(e)).toList();
  }

  Future<List<FoodModel>> getFavourites() async {
    final response = await _apiClient.get("/api/foods/favorites");
    
    final List decodedData = jsonDecode(response.body);
    return decodedData.map((e) => FoodModel.fromJson(e)).toList();
  }

  Future<void> addToFavourites(String id) async {
    await _apiClient.post("/api/foods/favorites/$id", {});
  }

  Future<void> removeFromFavourites(String id) async {
    await _apiClient.delete("/api/foods/favorites/$id");
  }

  Future<FoodModel> createCustomFood({
    required String name,
    required double calories,
    required FoodMacros macros,
    String? brand,
    String? servingSize,
  }) async {
    final bodyData = {
      'name': name,
      'calories': calories,
      'macros': macros.toJson(),
      if (brand != null) 'brand': brand,
      if (servingSize != null) 'servingSize': servingSize,
    };

    final response = await _apiClient.post(
      '/api/foods/custom',
       bodyData,
    );
    
    final Map<String, dynamic> decodedData = jsonDecode(response.body);
    return FoodModel.fromJson(decodedData);
  }
}