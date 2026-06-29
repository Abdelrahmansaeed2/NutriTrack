import '../../../core/network/api_client.dart';
import '../models/grocery_list_model.dart';

class GroceryService {
  static GroceryService? _instance;
  static GroceryService get instance {
    _instance ??= GroceryService._();
    return _instance!;
  }
  GroceryService._();

  /// GET /api/tracking/grocery
  Future<List<GroceryList>> getGroceryLists() async {
    final response = await ApiClient.instance.get('/api/tracking/grocery');
    final list = response.data as List<dynamic>;
    return list.map((e) => GroceryList.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// GET /api/tracking/grocery/:listId
  Future<GroceryList> getGroceryList(String listId) async {
    final response = await ApiClient.instance.get('/api/tracking/grocery/$listId');
    return GroceryList.fromJson(response.data as Map<String, dynamic>);
  }

  /// POST /api/tracking/grocery/:listId/item
  Future<void> addItem(String listId, String name, String quantity) async {
    await ApiClient.instance.post(
      '/api/tracking/grocery/$listId/item',
      data: {'name': name, 'quantity': quantity},
    );
  }

  /// PUT /api/tracking/grocery/:listId/item
  Future<void> toggleItem(String listId, String itemName, bool isChecked) async {
    await ApiClient.instance.put(
      '/api/tracking/grocery/$listId/item',
      data: {'itemName': itemName, 'isChecked': isChecked},
    );
  }

  /// DELETE /api/tracking/grocery/:listId/checked
  Future<void> clearChecked(String listId) async {
    await ApiClient.instance.delete('/api/tracking/grocery/$listId/checked');
  }
}
