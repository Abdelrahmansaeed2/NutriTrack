import 'package:equatable/equatable.dart';
import '../../features/tracking/models/food_item_model.dart';

enum FoodSearchStatus { initial, loading, loaded, error }

class FoodSearchState extends Equatable {
  final FoodSearchStatus status;
  final List<FoodItem> results;
  final String selectedCategory;
  final String query;
  final String? errorMessage;

  const FoodSearchState({
    this.status = FoodSearchStatus.initial,
    this.results = const [],
    this.selectedCategory = 'All',
    this.query = '',
    this.errorMessage,
  });

  FoodSearchState copyWith({
    FoodSearchStatus? status,
    List<FoodItem>? results,
    String? selectedCategory,
    String? query,
    String? errorMessage,
  }) {
    return FoodSearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, results, selectedCategory, query, errorMessage];
}
