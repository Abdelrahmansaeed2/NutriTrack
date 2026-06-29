import 'package:flutter_bloc/flutter_bloc.dart';
import 'api_food_search_state.dart';

class ApiFoodSearchCubit extends Cubit<ApiFoodSearchState> {
  ApiFoodSearchCubit() : super(const ApiFoodSearchState());

  void setTab(FoodSearchTab tab) {
    if (state.activeTab != tab) {
      emit(state.copyWith(activeTab: tab));
    }
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query, status: SearchStatus.loading));
    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!isClosed) {
        emit(state.copyWith(status: SearchStatus.success));
      }
    });
  }

  void setFilter(String filter) {
    if (state.activeFilter != filter) {
      emit(state.copyWith(activeFilter: filter, status: SearchStatus.loading));
      // Simulate API fetch based on filter
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!isClosed) {
          emit(state.copyWith(status: SearchStatus.success));
        }
      });
    }
  }
}
