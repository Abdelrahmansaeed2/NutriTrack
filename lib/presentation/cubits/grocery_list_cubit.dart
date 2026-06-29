import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/tracking/services/grocery_service.dart';
import '../../features/tracking/models/grocery_list_model.dart';
import '../../core/errors/api_exception.dart';
import 'grocery_list_state.dart';

class GroceryListCubit extends Cubit<GroceryListState> {
  GroceryListCubit() : super(const GroceryListState()) {
    loadLists();
  }

  Future<void> loadLists() async {
    emit(state.copyWith(status: GroceryStatus.loading));
    try {
      final lists = await GroceryService.instance.getGroceryLists();
      emit(state.copyWith(
        status: GroceryStatus.loaded,
        lists: lists,
        activeListId: lists.isNotEmpty ? lists.first.id : null,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: GroceryStatus.error, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(
        status: GroceryStatus.error,
        errorMessage: 'Failed to load grocery list.',
      ));
    }
  }

  Future<void> toggleItem(String itemName, bool currentValue) async {
    final listId = state.activeList?.id;
    if (listId == null) return;

    // Optimistic update
    final updatedLists = state.lists.map((list) {
      if (list.id != listId) return list;
      final updatedItems = list.items
          .map((item) => item.name == itemName
              ? item.copyWith(isChecked: !currentValue)
              : item)
          .toList();
      return GroceryList(
        id: list.id,
        planId: list.planId,
        createdAt: list.createdAt,
        items: updatedItems,
      );
    }).toList();
    emit(state.copyWith(lists: updatedLists));

    try {
      await GroceryService.instance.toggleItem(listId, itemName, !currentValue);
    } on ApiException catch (_) {
      // Roll back on error
      await loadLists();
    }
  }

  Future<void> addItem(String name, String quantity) async {
    final listId = state.activeList?.id;
    if (listId == null) return;
    try {
      await GroceryService.instance.addItem(listId, name, quantity);
      await loadLists();
    } on ApiException catch (e) {
      emit(state.copyWith(status: GroceryStatus.error, errorMessage: e.message));
    }
  }

  Future<void> clearChecked() async {
    final listId = state.activeList?.id;
    if (listId == null) return;
    try {
      await GroceryService.instance.clearChecked(listId);
      await loadLists();
    } on ApiException catch (e) {
      emit(state.copyWith(status: GroceryStatus.error, errorMessage: e.message));
    }
  }
}
