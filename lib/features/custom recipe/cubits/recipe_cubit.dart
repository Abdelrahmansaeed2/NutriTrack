import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/recipe_service.dart';
import '../models/custom_recipe_models.dart';
import 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final RecipeService _service;

  RecipeCubit(this._service) : super(RecipeInitial());

  Future<void> saveRecipe({
    required String name,
    required List<RecipeIngredient> ingredients,
    required RecipeMacros macros,
    String? date,
    String? mealType,
  }) async {
    emit(RecipeLoading());
    try {
      final success = await _service.createRecipe(
        name: name,
        ingredients: ingredients,
        macros: macros,
      );
      if (success) {
        if (date != null && mealType != null) {
          final logSuccess = await _service.logRecipeAsMeal(
            date: date,
            mealType: mealType,
            name: name,
            macros: macros,
          );
          if (!logSuccess) {
            emit(const RecipeError('Recipe saved, but failed to log to daily tracker'));
            return;
          }
        }
        emit(RecipeSuccess());
      } else {
        emit(const RecipeError('Failed to save recipe'));
      }
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
}
