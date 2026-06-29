import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/tracking/services/food_service.dart';
import '../../features/tracking/services/tracking_service.dart';
import '../../features/tracking/models/daily_log_model.dart';
import '../../core/errors/api_exception.dart';
import 'food_detail_state.dart';

class FoodDetailCubit extends Cubit<FoodDetailState> {
  FoodDetailCubit() : super(const FoodDetailState());

  Future<void> loadFood(String foodId) async {
    emit(state.copyWith(status: FoodDetailStatus.loading));
    try {
      final food = await FoodService.instance.getFoodById(foodId);
      emit(state.withFood(food));
    } on ApiException catch (e) {
      emit(state.copyWith(status: FoodDetailStatus.error, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(
        status: FoodDetailStatus.error,
        errorMessage: 'Failed to load food details.',
      ));
    }
  }

  void incrementServing() {
    emit(state.copyWith(servingGrams: state.servingGrams + 10));
  }

  void decrementServing() {
    if (state.servingGrams > 10) {
      emit(state.copyWith(servingGrams: state.servingGrams - 10));
    }
  }

  Future<void> addToLog(String mealType, DateTime date) async {
    final food = state.food;
    if (food == null) return;
    try {
      final item = MealItem(
        foodId: food.id,
        name: food.name,
        quantity: state.servingGrams.toDouble(),
        calories: state.currentKcal,
        macros: MealMacros(
          protein: state.currentProtein.toDouble(),
          carbs: state.currentCarbs.toDouble(),
          fat: state.currentFat.toDouble(),
        ),
      );
      await TrackingService.instance.logMeal(date, mealType, item);
      emit(state.copyWith(status: FoodDetailStatus.addedToLog));
    } on ApiException catch (e) {
      emit(state.copyWith(status: FoodDetailStatus.error, errorMessage: e.message));
    }
  }

  Future<void> toggleFavorite() async {
    final food = state.food;
    if (food == null) return;
    try {
      await FoodService.instance.addFavorite(food.id);
    } on ApiException catch (_) {
      // Non-critical — don't change UI state on failure
    }
  }
}
