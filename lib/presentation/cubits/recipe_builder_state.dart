import 'package:equatable/equatable.dart';
import '../../features/tracking/models/recipe_model.dart';

enum RecipeBuilderStatus { initial, loading, loaded, saving, saved, error }

// Keep the rich ingredient model for the UI builder
class RecipeIngredient extends Equatable {
  final String id;
  final String name;
  final String amount;
  final int kcal;
  final int protein;
  final int carbs;
  final int fat;

  const RecipeIngredient({
    required this.id,
    required this.name,
    required this.amount,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  List<Object?> get props => [id, name, amount, kcal, protein, carbs, fat];
}

class RecipeBuilderState extends Equatable {
  final RecipeBuilderStatus status;
  final String recipeName;
  final List<RecipeIngredient> ingredients;
  final List<Recipe> savedRecipes;
  final String? errorMessage;

  const RecipeBuilderState({
    this.status = RecipeBuilderStatus.initial,
    this.recipeName = '',
    this.ingredients = const [],
    this.savedRecipes = const [],
    this.errorMessage,
  });

  RecipeBuilderState copyWith({
    RecipeBuilderStatus? status,
    String? recipeName,
    List<RecipeIngredient>? ingredients,
    List<Recipe>? savedRecipes,
    String? errorMessage,
  }) {
    return RecipeBuilderState(
      status: status ?? this.status,
      recipeName: recipeName ?? this.recipeName,
      ingredients: ingredients ?? this.ingredients,
      savedRecipes: savedRecipes ?? this.savedRecipes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  int get totalKcal => ingredients.fold(0, (s, i) => s + i.kcal);
  int get totalProtein => ingredients.fold(0, (s, i) => s + i.protein);
  int get totalCarbs => ingredients.fold(0, (s, i) => s + i.carbs);
  int get totalFat => ingredients.fold(0, (s, i) => s + i.fat);
  bool get isValid => recipeName.trim().isNotEmpty && ingredients.isNotEmpty;

  @override
  List<Object?> get props =>
      [status, recipeName, ingredients, savedRecipes, errorMessage];
}
