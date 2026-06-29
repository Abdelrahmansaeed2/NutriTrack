import 'package:flutter/material.dart';
import '../models/plan_meal_model.dart';

class MealCard extends StatelessWidget {
  final String mealType;
  final List<PlanMeal> meals;
  final bool isSwapping;
  final VoidCallback onSwap;

  const MealCard({
    super.key,
    required this.mealType,
    required this.meals,
    required this.isSwapping,
    required this.onSwap,
  });

  bool get _isEmpty => meals.isEmpty;
  PlanMeal? get _currentMeal => meals.isNotEmpty ? meals.first : null;  

  IconData get _mealIcon {
    switch (mealType) {
      case 'breakfast': return Icons.wb_sunny_outlined;
      case 'lunch':     return Icons.lunch_dining_outlined;
      case 'dinner':    return Icons.dinner_dining_outlined;
      case 'snacks':    return Icons.apple_outlined;
      default:          return Icons.restaurant_outlined;
    }
  }

  String get _mealLabel => mealType[0].toUpperCase() + mealType.substring(1);

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(_mealIcon, size: 18, color: const Color(0xFF1DB574)),
                const SizedBox(width: 6),
                Text(
                  _mealLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            if (!_isEmpty)
              Row(
                children: [
                  const Icon(Icons.local_fire_department_outlined,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 2),
                  Text(
                    '${_currentMeal!.calories.toInt()} kcal',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isEmpty)
          Row(
            children: [
              const Icon(Icons.add_circle_outline,
                  color: Color(0xFF1DB574), size: 20),
              const SizedBox(width: 8),
              Text(
                'No meal planned',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
            ],
          )
        else
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.restaurant, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentMeal!.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'P: ${_currentMeal!.protein.toInt()}g  '
                      'C: ${_currentMeal!.carbs.toInt()}g  '
                      'F: ${_currentMeal!.fat.toInt()}g',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: isSwapping
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF1DB574),
                  ),
                )
              : GestureDetector(
                  onTap: onSwap,
                  child: Text(
                    _isEmpty ? 'Add Meal' : 'Swap Meal',
                    style: const TextStyle(
                      color: Color(0xFF1DB574),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
        ),
      ],
    ),
  );
}
}