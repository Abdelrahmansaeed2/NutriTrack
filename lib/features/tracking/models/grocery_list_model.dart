class GroceryList {
  final String id;
  final String planId;
  final DateTime createdAt;
  final List<GroceryListItem> items;

  const GroceryList({
    required this.id,
    required this.planId,
    required this.createdAt,
    required this.items,
  });

  factory GroceryList.fromJson(Map<String, dynamic> json) {
    return GroceryList(
      id: json['id'] as String? ?? '',
      planId: json['planId'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) =>
                  GroceryListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  int get totalItems => items.length;
  int get checkedItems => items.where((i) => i.isChecked).length;
}

class GroceryListItem {
  final String name;
  final String quantity;
  final bool isChecked;

  const GroceryListItem({
    required this.name,
    required this.quantity,
    required this.isChecked,
  });

  factory GroceryListItem.fromJson(Map<String, dynamic> json) {
    return GroceryListItem(
      name: json['name'] as String? ?? '',
      quantity: json['quantity'] as String? ?? '',
      isChecked: json['isChecked'] as bool? ?? false,
    );
  }

  GroceryListItem copyWith({bool? isChecked}) {
    return GroceryListItem(
      name: name,
      quantity: quantity,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
