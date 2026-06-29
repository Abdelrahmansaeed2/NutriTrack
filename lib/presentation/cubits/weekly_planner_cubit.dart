import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/ai_planner/services/ai_service.dart';
import '../../core/errors/api_exception.dart';
import 'weekly_planner_state.dart';

class WeeklyPlannerCubit extends Cubit<WeeklyPlannerState> {
  WeeklyPlannerCubit()
      : super(WeeklyPlannerState(selectedDate: DateTime.now())) {
    loadPlan();
  }

  Future<void> loadPlan() async {
    emit(state.copyWith(status: WeeklyPlannerStatus.loading));
    try {
      final plan = await AiService.instance.getLatestWeeklyPlan();
      emit(state.copyWith(
        status: WeeklyPlannerStatus.loaded,
        plan: plan,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: WeeklyPlannerStatus.error,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: WeeklyPlannerStatus.error,
        errorMessage: 'No meal plan found. Generate one from the AI Planner.',
      ));
    }
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  Future<void> swapMeal(String date, String mealType) async {
    final plan = state.plan;
    if (plan == null) return;
    emit(state.copyWith(status: WeeklyPlannerStatus.swapping));
    try {
      await AiService.instance.swapMeal(plan.id, date, mealType);
      // Reload plan to get the updated meal
      await loadPlan();
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: WeeklyPlannerStatus.error,
        errorMessage: e.message,
      ));
    }
  }
}
