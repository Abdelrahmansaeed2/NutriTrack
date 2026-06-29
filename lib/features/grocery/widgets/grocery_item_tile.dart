import 'package:flutter/material.dart';
import '../models/grocery_item_model.dart';

class GroceryItemTile extends StatelessWidget {
  final GroceryItem item;
  final ValueChanged<bool> onToggle;

  const GroceryItemTile({
    super.key,
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onToggle(!item.isChecked),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: item.isChecked ? const Color(0xFF1DB574) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: item.isChecked
                      ? const Color(0xFF1DB574)
                      : Colors.grey[300]!,
                  width: 1.5,
                ),
              ),
              child: item.isChecked
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.name,
              style: TextStyle(
                fontSize: 14,
                color: item.isChecked ? Colors.grey[400] : Colors.black87,
                decoration:
                    item.isChecked ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          Text(
            item.quantity,
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}