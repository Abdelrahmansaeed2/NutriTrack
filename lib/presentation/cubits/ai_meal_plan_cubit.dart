import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/ai_planner/services/ai_service.dart';
import '../../core/errors/api_exception.dart';
import 'ai_meal_plan_state.dart';

class AIMealPlanCubit extends Cubit<AIMealPlanState> {
  AIMealPlanCubit() : super(const AIMealPlanState());

  void toggleVegetarian() => emit(state.copyWith(isVegetarian: !state.isVegetarian));
  void toggleKeto() => emit(state.copyWith(isKeto: !state.isKeto));
  void toggleHalal() => emit(state.copyWith(isHalal: !state.isHalal));
  void updateAllergies(String text) => emit(state.copyWith(allergiesText: text));
  void updateDailyMeals(double meals) => emit(state.copyWith(dailyMeals: meals.toInt()));

  /// Calls real Groq-powered AI endpoint to generate the weekly plan
  Future<void> generatePlan() async {
    emit(state.copyWith(status: AIMealPlanStatus.loading, errorMessage: null));
    try {
      final plan = await AiService.instance.generateWeeklyPlan(
        startDate: DateTime.now(),
      );
      emit(state.copyWith(
        status: AIMealPlanStatus.generated,
        generatedPlanId: plan.id,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: AIMealPlanStatus.error,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: AIMealPlanStatus.error,
        errorMessage: 'AI plan generation failed. Please try again.',
      ));
    }
  }

  /// After plan is generated, generate grocery list automatically
  Future<void> generateGroceryList(String planId) async {
    try {
      await AiService.instance.generateGroceryList(planId);
    } catch (_) {
      // Non-critical failure — grocery list can be generated later
    }
  }
}
