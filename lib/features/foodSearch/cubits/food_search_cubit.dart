

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_track/features/foodSearch/cubits/food_search_state.dart';
import 'package:nutri_track/features/foodSearch/services/food_search_service.dart';

class FoodSearchCubit extends Cubit<FoodSearchState> {
  final FoodSearchService _service;
  List<String> _favoriteIds = [];


  FoodSearchCubit(this._service) : super(FoodSearchInitial());
  
  Future<void> loadFavourites() async {
  try {
    final favorites = await _service.getFavourites();
    _favoriteIds = favorites.map((f) => f.id).toList();

    if (state is FoodSearchLoaded) {
      final current = state as FoodSearchLoaded;
      emit(FoodSearchLoaded(
        foods: current.foods,
        selectedTag: current.selectedTag,
        favouriteIds: List.from(_favoriteIds),
      ));
    }
  } catch (e) {
  }
}


  Future<void> searchFoods({
  required String query,
  String selectedTag = 'all',
}) async {
  emit(FoodSearchLoading());
  try {
    final foods = await _service.searchFoods(query: query, tag: selectedTag);
        print('foods loaded: ${foods.length}');
    emit(FoodSearchLoaded(
      foods: foods,
      selectedTag: selectedTag,
      favouriteIds: _favoriteIds, 
    ));
  } catch (e) {
    emit(FoodSearchError(e.toString()));
  }
}
  Future<void> toggleFavorite(String foodId) async {
  if (state is! FoodSearchLoaded) return;
  final current = state as FoodSearchLoaded;

  final isCurrentlyFavorite = _favoriteIds.contains(foodId);

  if (isCurrentlyFavorite) {
    _favoriteIds.remove(foodId);
  } else {
    _favoriteIds.add(foodId);
  }

  emit(FoodSearchLoaded(
    foods: current.foods,
    selectedTag: current.selectedTag,
    favouriteIds: List.from(_favoriteIds),
  ));

  try {
    if (isCurrentlyFavorite) {
      await _service.removeFromFavourites(foodId);
    } else {
      await _service.addToFavourites(foodId);
    }
  } catch (e) {
    if (isCurrentlyFavorite) {
      _favoriteIds.add(foodId);
    } else {
      _favoriteIds.remove(foodId);
    }
    emit(FoodSearchLoaded(
      foods: current.foods,
      selectedTag: current.selectedTag,
      favouriteIds: List.from(_favoriteIds),
    ));
    emit(FoodSearchError('Failed to update favorite $e'));
  }
}

}