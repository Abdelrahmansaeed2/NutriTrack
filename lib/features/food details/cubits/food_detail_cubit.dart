import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/food_detail_service.dart';
import 'food_detail_state.dart';

class FoodDetailCubit extends Cubit<FoodDetailState> {
  final FoodDetailService _service;

  FoodDetailCubit(this._service) : super(FoodDetailInitial());

  Future<void> logMeal({
    required String date,
    required String mealType,
    required String foodId,
    required String name,
    required double quantity,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
  }) async {
    emit(FoodDetailSubmitting());
    try {
      final success = await _service.logMealItem(
        date: date,
        mealType: mealType,
        foodId: foodId,
        name: name,
        quantity: quantity,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
      );
      if (success) {
        emit(const FoodDetailSuccess('Meal logged successfully!'));
      } else {
        emit(const FoodDetailError('Failed to log meal.'));
      }
    } catch (e) {
      emit(FoodDetailError(e.toString()));
    }
  }

  Future<void> toggleFavorite(String foodId, bool isFavorite) async {
    try {
      await _service.toggleFavorite(foodId, isFavorite);
    } catch (_) {}
  }
}
