class GroceryItem {
  final String name;
  final String quantity;
  final String category;
  final bool isChecked;

  const GroceryItem({
    required this.name,
    required this.quantity,
    required this.category,
    this.isChecked = false,
  });

  factory GroceryItem.fromJson(Map<String, dynamic> json) => GroceryItem(
        name: json['name'],
        quantity: json['quantity'],
        category: json['category'] ?? 'Other',
        isChecked: json['isChecked'] ?? false,
      );

  GroceryItem copyWith({bool? isChecked}) => GroceryItem(
        name: name,
        quantity: quantity,
        category: category,
        isChecked: isChecked ?? this.isChecked,
      );
}