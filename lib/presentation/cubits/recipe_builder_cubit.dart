import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/tracking/services/recipe_service.dart';
import '../../features/tracking/models/recipe_model.dart';
import '../../core/errors/api_exception.dart';
import 'recipe_builder_state.dart';

class RecipeBuilderCubit extends Cubit<RecipeBuilderState> {
  RecipeBuilderCubit() : super(const RecipeBuilderState()) {
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    emit(state.copyWith(status: RecipeBuilderStatus.loading));
    try {
      final recipes = await RecipeService.instance.getRecipes();
      emit(state.copyWith(
        status: RecipeBuilderStatus.loaded,
        savedRecipes: recipes,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: RecipeBuilderStatus.error, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(
        status: RecipeBuilderStatus.error,
        errorMessage: 'Failed to load recipes.',
      ));
    }
  }

  void updateName(String name) {
    emit(state.copyWith(recipeName: name));
  }

  void addIngredient(RecipeIngredient ingredient) {
    final updated = [...state.ingredients, ingredient];
    emit(state.copyWith(ingredients: updated));
  }

  void removeIngredient(String id) {
    final updated = state.ingredients.where((i) => i.id != id).toList();
    emit(state.copyWith(ingredients: updated));
  }

  void clearBuilder() {
    emit(state.copyWith(
      recipeName: '',
      ingredients: [],
      status: RecipeBuilderStatus.loaded,
    ));
  }

  Future<void> saveRecipe() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: RecipeBuilderStatus.saving));
    try {
      final recipe = Recipe(
        id: '',
        name: state.recipeName,
        totals: RecipeTotals(
          calories: state.totalKcal,
          protein: state.totalProtein,
          carbs: state.totalCarbs,
          fat: state.totalFat,
        ),
        ingredients: state.ingredients
            .map((i) => RecipeIngredientItem(
                  name: i.name,
                  quantity: i.amount,
                  calories: i.kcal,
                ))
            .toList(),
      );
      final saved = await RecipeService.instance.createRecipe(recipe);
      final updatedList = [saved, ...state.savedRecipes];
      emit(state.copyWith(
        status: RecipeBuilderStatus.saved,
        savedRecipes: updatedList,
        recipeName: '',
        ingredients: [],
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: RecipeBuilderStatus.error, errorMessage: e.message));
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      await RecipeService.instance.deleteRecipe(id);
      final updated = state.savedRecipes.where((r) => r.id != id).toList();
      emit(state.copyWith(savedRecipes: updated));
    } on ApiException catch (e) {
      emit(state.copyWith(status: RecipeBuilderStatus.error, errorMessage: e.message));
    }
  }
}
