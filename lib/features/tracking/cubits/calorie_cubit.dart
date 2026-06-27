import 'package:flutter_bloc/flutter_bloc.dart';

class CalorieState {
  final int dailyGoal;
  final int caloriesEaten;

  const CalorieState({
    required this.dailyGoal,
    required this.caloriesEaten,
  });

  int get remainingCalories => dailyGoal - caloriesEaten;

  CalorieState copyWith({
    int? dailyGoal,
    int? caloriesEaten,
  }) {
    return CalorieState(
      dailyGoal: dailyGoal ?? this.dailyGoal,
      caloriesEaten: caloriesEaten ?? this.caloriesEaten,
    );
  }
}

class CalorieCubit extends Cubit<CalorieState> {
  CalorieCubit() : super(const CalorieState(dailyGoal: 2000, caloriesEaten: 0));

  void setGoal(int goal) {
    emit(state.copyWith(dailyGoal: goal));
  }

  void addCalories(int amount) {
    emit(state.copyWith(caloriesEaten: state.caloriesEaten + amount));
  }
}
