import '../../../core/network/api_client.dart';
import '../models/food_item_model.dart';

class FoodService {
  static FoodService? _instance;
  static FoodService get instance {
    _instance ??= FoodService._();
    return _instance!;
  }
  FoodService._();

  /// GET /api/foods/search?query=...&tag=...
  Future<List<FoodItem>> searchFoods(String query, {String? tag}) async {
    final params = <String, dynamic>{'query': query};
    if (tag != null && tag != 'All') params['tag'] = tag;
    final response = await ApiClient.instance.get('/api/foods/search', queryParameters: params);
    final list = response.data as List<dynamic>;
    return list.map((e) => FoodItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// GET /api/foods/:id
  Future<FoodItem> getFoodById(String id) async {
    final response = await ApiClient.instance.get('/api/foods/$id');
    return FoodItem.fromJson(response.data as Map<String, dynamic>);
  }

  /// POST /api/foods/barcode
  Future<FoodItem> scanBarcode(String barcode) async {
    final response = await ApiClient.instance.post(
      '/api/foods/barcode',
      data: {'barcode': barcode},
    );
    return FoodItem.fromJson(response.data as Map<String, dynamic>);
  }

  /// GET /api/foods/favorites
  Future<List<FoodItem>> getFavorites() async {
    final response = await ApiClient.instance.get('/api/foods/favorites');
    final list = response.data as List<dynamic>;
    return list.map((e) => FoodItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// POST /api/foods/favorites/:id
  Future<void> addFavorite(String id) async {
    await ApiClient.instance.post('/api/foods/favorites/$id');
  }

  /// DELETE /api/foods/favorites/:id
  Future<void> removeFavorite(String id) async {
    await ApiClient.instance.delete('/api/foods/favorites/$id');
  }

  /// POST /api/foods/custom
  Future<FoodItem> createCustomFood(Map<String, dynamic> data) async {
    final response = await ApiClient.instance.post('/api/foods/custom', data: data);
    return FoodItem.fromJson(response.data as Map<String, dynamic>);
  }
}
