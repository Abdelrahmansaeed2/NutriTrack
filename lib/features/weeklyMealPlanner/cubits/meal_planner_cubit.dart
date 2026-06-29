import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_track/features/weeklyMealPlanner/cubits/meal_planner_state.dart';
import 'package:nutri_track/features/weeklyMealPlanner/services/meal_planner_service.dart';

class MealPlannerCubit extends Cubit<MealPlannerState> {
  final MealPlannerService _service;
  
  MealPlannerCubit(this._service) : super(MealPlannerInitial());

  Future<void> LoadLatestPlan() async{
    emit(MealPlannerLoading());

    try{
    final response = await _service.getLatestWeeklyPlan();

    emit(MealPlannerLoaded(plan: response, selectedDate: response.startDate));
    }
    catch(e){
      emit(MealPlannerError(message: e.toString()));
    }
  }
  

  Future<void> generatePlan(String startdate) async{
    emit(MealPlannerGenerating());

    try{
      final plan = await _service.generateWeeklyPlan(startdate);
      emit(MealPlannerLoaded(plan: plan, selectedDate: startdate));
    }
    catch(e){
            emit(MealPlannerError(message: e.toString()));
    }
  }

  void selectDate(String date) {
    if (state is MealPlannerLoaded) {
      final current = state as MealPlannerLoaded;
      emit(MealPlannerLoaded(
        plan: current.plan,
        selectedDate: date,
      ));
    }
  }

  Future<void> swapMeal(String mealType) async {
    if (state is! MealPlannerLoaded) return;
    final current = state as MealPlannerLoaded;

    emit(MealSwapping(
      plan: current.plan,
      selectedDate: current.selectedDate,
      swappingMealType: mealType,
    ));

    try {
       await _service.swapMeal(
        planId: current.plan.id,
        date: current.selectedDate,
        mealType: mealType,
      );
      
      final updatedPlan = await _service.getLatestWeeklyPlan();
      emit(MealPlannerLoaded(
        plan: updatedPlan,
        selectedDate: current.selectedDate,
      ));
    } catch (e) {
      emit(MealPlannerLoaded(
        plan: current.plan,
        selectedDate: current.selectedDate,
      ));
      emit(MealPlannerError(message: 'Failed to swap meal: $e'));
    }
  }
}
