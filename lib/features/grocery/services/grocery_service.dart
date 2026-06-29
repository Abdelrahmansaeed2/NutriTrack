import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nutri_track/core/networking/api_service.dart';
import '../models/grocery_list_model.dart';

class GroceryService {
  
  final ApiClient _apiClient;
  GroceryService(this._apiClient);

  Future<List<GroceryList>> getGroceryLists() async {
    final response = await _apiClient.get('/api/tracking/grocery');
    final List decodedData = jsonDecode(response.body);
    return decodedData.map((e) => GroceryList.fromJson(e)).toList();
  }

  Future<GroceryList> getGroceryListById(String listId) async {
    final response = await _apiClient.get('/api/tracking/grocery/$listId');
    return GroceryList.fromJson(jsonDecode(response.body));
  }

  Future<String> getLatestWeeklyPlanId() async {
  final response = await _apiClient.get('/api/ai/weekly-plan');
  final data = jsonDecode(response.body);
  return data['id'] as String;
}

  Future<void> updateItemStatus({
    required String listId,
    required String itemName,
    required bool isChecked,
  }) async {
    await _apiClient.put(
      '/api/tracking/grocery/$listId/item',
       {
        'itemName': itemName,
        'isChecked': isChecked,
      }
    );
  }

  Future<void> clearCheckedItems(String listId) async {
    await _apiClient.delete('/api/tracking/grocery/$listId/checked');
  }

  Future<void> addItem({
    required String listId,
    required String name,
    required String quantity,
      required String category,
  }) async {
    await _apiClient.post(
      '/api/tracking/grocery/$listId/item',
       {
         'name': name,
      'quantity': quantity,
      'category': category,
      }
    );
  }

  Future<GroceryList> generateGroceryList(String planId) async {
    final response = await _apiClient.post(
      '/api/ai/generate-grocery-list',
       {'planId': planId},
    );
    return GroceryList.fromJson(jsonDecode(response.body)['groceryList']);
  }
}