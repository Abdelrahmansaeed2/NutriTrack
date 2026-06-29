import 'package:flutter/material.dart';

class GroceryProgressCard extends StatelessWidget {
  final int totalItems;
  final int remainingItems;
  final VoidCallback onClearChecked;

  const GroceryProgressCard({
    super.key,
    required this.totalItems,
    required this.remainingItems,
    required this.onClearChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.check_circle_outline,
                color: Color(0xFF1DB574), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progress',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'You have $remainingItems items left to buy.',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClearChecked,
            child: const Text(
              'Clear\nChecked',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1DB574),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}