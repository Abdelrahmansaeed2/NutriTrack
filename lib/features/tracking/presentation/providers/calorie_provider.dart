import 'package:flutter/material.dart';

class CalorieProvider extends ChangeNotifier {
  int _dailyGoal = 2000;
  int _caloriesEaten = 0;

  int get dailyGoal => _dailyGoal;
  int get caloriesEaten => _caloriesEaten;
  int get remainingCalories => _dailyGoal - _caloriesEaten;

  void setGoal(int goal) {
    _dailyGoal = goal;
    notifyListeners();
  }

  void addCalories(int amount) {
    _caloriesEaten += amount;
    notifyListeners();
  }
}
