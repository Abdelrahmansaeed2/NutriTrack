import 'grocery_item_model.dart';

class GroceryList {
  final String id;
  final String planId;
  final String weekOf;
  final String createdAt;
  final List<GroceryItem> items;

  const GroceryList({
    required this.id,
    required this.planId,
    required this.weekOf,
    required this.createdAt,
    required this.items,
  });

  Map<String, List<GroceryItem>> get groupedByCategory {
    final Map<String, List<GroceryItem>> grouped = {};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    return grouped;
  }

  int get totalItems => items.length;
  int get checkedItems => items.where((i) => i.isChecked).length;
  int get remainingItems => totalItems - checkedItems;

  factory GroceryList.fromJson(Map<String, dynamic> json) => GroceryList(
        id: json['id'],
        planId: json['planId'],
        weekOf: json['weekOf'],
        createdAt: json['createdAt'],
        items: (json['items'] as List? ?? [])
            .map((e) => GroceryItem.fromJson(e))
            .toList(),
      );
}