

import 'package:nutri_track/features/weeklyMealPlanner/models/weekly_plan_model.dart';

abstract class MealPlannerState {}


class MealPlannerInitial extends MealPlannerState {}


class MealPlannerLoading extends MealPlannerState {}


class MealPlannerLoaded extends MealPlannerState {
  final WeeklyPlan plan;
  final String selectedDate;

  MealPlannerLoaded({required this.plan, required this.selectedDate});
  
}

class MealSwapping extends MealPlannerState {
  final WeeklyPlan plan;
  final String selectedDate;
  final String swappingMealType;

  MealSwapping({
    required this.plan,
    required this.selectedDate,
    required this.swappingMealType,
  });
}

class MealPlannerGenerating extends MealPlannerState {}

class MealPlannerError extends MealPlannerState{
  final String message;

  MealPlannerError({required this.message});
}

