import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/recipe_service.dart';
import '../models/custom_recipe_models.dart';
import 'recipe_state.dart';
import '../../daily dashboard/cubits/daily_dashboard_cubit.dart';
import '../../daily dashboard/cubits/daily_dashboard_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final RecipeService _service;

  RecipeCubit(this._service) : super(RecipeInitial());

  Future<void> saveRecipe({
    required String name,
    required List<RecipeIngredient> ingredients,
    required RecipeMacros macros,
    String? date,
    String? mealType,
    DailyDashboardCubit? dashboardCubit,
  }) async {
    print('💾 saveRecipe → name=$name date=$date mealType=$mealType totalKcal=${macros.totalKcal}');
    emit(RecipeLoading());
    try {
      final success = await _service.createRecipe(
        name: name,
        ingredients: ingredients,
        macros: macros,
      );
      if (success) {
        if (date != null && mealType != null) {
          print('📋 Attempting to log recipe to daily log...');
          final updatedLog = await _service.logRecipeAsMeal(
            date: date,
            mealType: mealType,
            name: name,
            macros: macros,
          );
          print('📋 logRecipeAsMeal result: $updatedLog');
          if (updatedLog == null) {
            emit(const RecipeError('Recipe saved, but failed to log to daily tracker'));
            return;
          }
          // Immediately push the updated log into the dashboard cubit
          // so the home screen updates without a second network call
          dashboardCubit?.emit(DailyDashboardLoaded(updatedLog));
        } else {
          print('⚠️ date or mealType is null — skipping daily log. date=$date mealType=$mealType');
        }
        emit(RecipeSuccess());
      } else {
        emit(const RecipeError('Failed to save recipe'));
      }
    } catch (e) {
      print('💾 saveRecipe exception: $e');
      emit(RecipeError(e.toString()));
    }
  }
}
