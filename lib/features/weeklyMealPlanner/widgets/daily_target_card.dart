import 'package:flutter/material.dart';
import 'package:nutri_track/features/weeklyMealPlanner/widgets/macro_row.dart';
import '../models/day_plan_model.dart';

class DailyTargetsCard extends StatelessWidget {
  final DayPlan dayPlan;
  final double targetCalories;
  final double targetProtein;
  final double targetCarbs;
  final double targetFat;

  const DailyTargetsCard({
    super.key,
    required this.dayPlan,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFat,
  });

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
              const Text(
                'Daily Targets',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              Text(
                '${dayPlan.totalCalories.toInt()} kcal',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          MacroRow(
            label: 'Protein',
            value: dayPlan.totalProtein,
            target: targetProtein,
            color: const Color(0xFF5B8CFF),
          ),
          const SizedBox(height: 8),
          MacroRow(
            label: 'Carbs',
            value: dayPlan.totalCarbs,
            target: targetCarbs,
            color: const Color(0xFFFF6B6B),
          ),
          const SizedBox(height: 8),
          MacroRow(
            label: 'Fats',
            value: dayPlan.totalFat,
            target: targetFat,
            color: const Color(0xFF4CAF50),
          ),
        ],
      ),
    );
  }
}

