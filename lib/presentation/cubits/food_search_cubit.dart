import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/tracking/services/food_service.dart';
import '../../core/errors/api_exception.dart';
import 'food_search_state.dart';

class FoodSearchCubit extends Cubit<FoodSearchState> {
  FoodSearchCubit() : super(const FoodSearchState()) {
    search('');
  }

  Future<void> search(String query) async {
    final category = state.selectedCategory;
    emit(state.copyWith(status: FoodSearchStatus.loading, query: query));
    try {
      final results = await FoodService.instance.searchFoods(
        query,
        tag: category == 'All' ? null : category,
      );
      emit(state.copyWith(
        status: FoodSearchStatus.loaded,
        results: results,
        query: query,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: FoodSearchStatus.error,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: FoodSearchStatus.error,
        errorMessage: 'Failed to search foods.',
      ));
    }
  }

  Future<void> selectCategory(String category) async {
    emit(state.copyWith(
      status: FoodSearchStatus.loading,
      selectedCategory: category,
    ));
    try {
      final results = await FoodService.instance.searchFoods(
        state.query,
        tag: category == 'All' ? null : category,
      );
      emit(state.copyWith(
        status: FoodSearchStatus.loaded,
        results: results,
        selectedCategory: category,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: FoodSearchStatus.error,
        errorMessage: e.message,
      ));
    }
  }
}
