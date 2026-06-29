import 'package:flutter/material.dart';
import '../models/grocery_item_model.dart';
import 'grocery_item_tile.dart';

class GroceryCategorySection extends StatelessWidget {
  final String category;
  final List<GroceryItem> items;
  final ValueChanged<GroceryItem> onToggle;

  const GroceryCategorySection({
    super.key,
    required this.category,
    required this.items,
    required this.onToggle,
  });

  IconData get _categoryIcon {
    switch (category.toLowerCase()) {
      case 'produce':         return Icons.eco_outlined;
      case 'dairy':           return Icons.water_drop_outlined;
      case 'meat & proteins': return Icons.set_meal_outlined;
      case 'grains':          return Icons.grain_outlined;
      case 'pantry':          return Icons.kitchen_outlined;
      case 'beverages':       return Icons.local_drink_outlined;
      default:                return Icons.shopping_basket_outlined;
    }
  }

  Color get _categoryColor {
    switch (category.toLowerCase()) {
      case 'produce':         return const Color(0xFF4CAF50);
      case 'dairy':           return const Color(0xFF2196F3);
      case 'meat & proteins': return const Color(0xFFE53935);
      case 'grains':          return const Color(0xFFFF9800);
      case 'pantry':          return const Color(0xFF795548);
      case 'beverages':       return const Color(0xFF00BCD4);
      default:                return const Color(0xFF9E9E9E);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_categoryIcon, size: 18, color: _categoryColor),
              const SizedBox(width: 8),
              Text(
                category,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _categoryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          ...items.map((item) => Column(
                children: [
                  GroceryItemTile(
                    item: item,
                    onToggle: (checked) => onToggle(item.copyWith(isChecked: checked)),
                  ),
                  if (item != items.last)
                    Divider(height: 1, color: Colors.grey[100]),
                ],
              )),
        ],
      ),
    );
  }
}