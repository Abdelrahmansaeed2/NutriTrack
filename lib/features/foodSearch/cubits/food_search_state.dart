import 'package:nutri_track/features/foodSearch/models/food_meal.dart';


enum FoodSearchTab { database, barcode }

abstract class FoodSearchState {}

class FoodSearchInitial extends FoodSearchState {}

class FoodSearchLoading extends FoodSearchState {}

class FoodSearchLoaded extends FoodSearchState {
  final List<FoodModel> foods;
  final String selectedTag;
  final FoodSearchTab activeTab;
  final List<String> favouriteIds;
  FoodSearchLoaded({
    required this.foods,
    required this.favouriteIds,
    this.selectedTag = 'all',
    this.activeTab = FoodSearchTab.database,
 });

    bool isFavourite(String id) => favouriteIds.contains(id);
}


class FoodSearchError extends FoodSearchState {
  final String message;
  FoodSearchError(this.message);
}