
import 'package:flutter/material.dart';


class DayItem {
  final String dayName;
  final int dayNumber;
  final bool isActive;

  const DayItem(this.dayName, this.dayNumber, {this.isActive = false});
}


class MacroData {
  final String label;
  final int current;
  final int target;
  final Color barColor;
  final Color trackColor;

  const MacroData({
    required this.label,
    required this.current,
    required this.target,
    required this.barColor,
    required this.trackColor,
  });

  double get progress => (current / target).clamp(0.0, 1.0);
}

class FoodEntry {
  final String name;
  final String detail;
  final int kcal;

  const FoodEntry(this.name, this.detail, this.kcal);
}

class MealSection {
  final String title;
  final IconData icon;
  final int totalKcal;
  final List<FoodEntry> entries;
  final bool isEmpty;
  final String? recommendation;

  const MealSection({
    required this.title,
    required this.icon,
    required this.totalKcal,
    this.entries = const [],
    this.isEmpty = false,
    this.recommendation,
  });
}