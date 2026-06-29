import 'package:equatable/equatable.dart';
import '../../features/tracking/models/food_item_model.dart';

enum FoodDetailStatus { initial, loading, loaded, error, addedToLog }

class FoodDetailState extends Equatable {
  final FoodDetailStatus status;
  final FoodItem? food;
  final int servingGrams;
  final String? errorMessage;

  // Base macros per gram — computed once from API data
  final double _baseProtein;
  final double _baseCarbs;
  final double _baseFat;
  final double _baseKcal;

  const FoodDetailState({
    this.status = FoodDetailStatus.initial,
    this.food,
    this.servingGrams = 100,
    this.errorMessage,
    double baseProtein = 0,
    double baseCarbs = 0,
    double baseFat = 0,
    double baseKcal = 0,
  })  : _baseProtein = baseProtein,
        _baseCarbs = baseCarbs,
        _baseFat = baseFat,
        _baseKcal = baseKcal;

  int get currentProtein => (_baseProtein * servingGrams).round();
  int get currentCarbs => (_baseCarbs * servingGrams).round();
  int get currentFat => (_baseFat * servingGrams).round();
  int get currentKcal => (_baseKcal * servingGrams).round();

  FoodDetailState copyWith({
    FoodDetailStatus? status,
    FoodItem? food,
    int? servingGrams,
    String? errorMessage,
  }) {
    return FoodDetailState(
      status: status ?? this.status,
      food: food ?? this.food,
      servingGrams: servingGrams ?? this.servingGrams,
      errorMessage: errorMessage ?? this.errorMessage,
      baseProtein: _baseProtein,
      baseCarbs: _baseCarbs,
      baseFat: _baseFat,
      baseKcal: _baseKcal,
    );
  }

  /// Create state from a loaded FoodItem, normalising macros per gram
  FoodDetailState withFood(FoodItem item) {
    // servingSize is a display string like "4 oz" — we default to 100g base
    final protein = item.macros.protein;
    final carbs = item.macros.carbs;
    final fat = item.macros.fat;
    final kcal = item.calories.toDouble();
    return FoodDetailState(
      status: FoodDetailStatus.loaded,
      food: item,
      servingGrams: 100,
      baseProtein: protein / 100,
      baseCarbs: carbs / 100,
      baseFat: fat / 100,
      baseKcal: kcal / 100,
    );
  }

  @override
  List<Object?> get props => [status, food, servingGrams, errorMessage];
}
