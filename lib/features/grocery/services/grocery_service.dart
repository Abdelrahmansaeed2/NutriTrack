import 'package:dio/dio.dart';
import '../models/grocery_list_model.dart';

class GroceryService {
  final Dio _dio;

  GroceryService(this._dio);

  Future<List<GroceryList>> getGroceryLists() async {
    final response = await _dio.get('/api/tracking/grocery');
    final List decodedData = response.data as List;
    return decodedData.map((e) => GroceryList.fromJson(e)).toList();
  }

  Future<GroceryList> getGroceryListById(String listId) async {
    final response = await _dio.get('/api/tracking/grocery/$listId');
    return GroceryList.fromJson(response.data as Map<String, dynamic>);
  }

  Future<String?> getLatestWeeklyPlanId() async {
    try {
      final response = await _dio.get('/api/ai/weekly-plan');
      if (response.statusCode == 200 && response.data != null) {
        return response.data['id'] as String?;
      }
    } catch (_) {}
    return null;
  }

  Future<void> updateItemStatus({
    required String listId,
    required String itemName,
    required bool isChecked,
  }) async {
    await _dio.put(
      '/api/tracking/grocery/$listId/item',
      data: {
        'itemName': itemName,
        'isChecked': isChecked,
      },
    );
  }

  Future<void> clearCheckedItems(String listId) async {
    await _dio.delete('/api/tracking/grocery/$listId/checked');
  }

  Future<void> addItem({
    required String listId,
    required String name,
    required String quantity,
    required String category,
  }) async {
    await _dio.post(
      '/api/tracking/grocery/$listId/item',
      data: {
        'name': name,
        'quantity': quantity,
        'category': category,
      },
    );
  }

  Future<GroceryList> generateGroceryList(String planId) async {
    final response = await _dio.post(
      '/api/ai/generate-grocery-list',
      data: {'planId': planId},
    );
    return GroceryList.fromJson(response.data['groceryList'] as Map<String, dynamic>);
  }
}