import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/grocery_list_model.dart';
import '../services/grocery_service.dart';
import 'grocery_state.dart';

class GroceryCubit extends Cubit<GroceryState> {
  final GroceryService _service;

  GroceryCubit(this._service) : super(GroceryInitial());

  Future<void> loadGroceryLists() async {
    emit(GroceryLoading());
    try {
      final lists = await _service.getGroceryLists();
      if (lists.isEmpty) {
        final planId = await _service.getLatestWeeklyPlanId();
        if (planId != null) {
          emit(GroceryNoListButPlanExists(planId));
        } else {
          emit(GroceryError('No grocery lists found. Please generate a weekly plan first.'));
        }
        return;
      }
      emit(GroceryLoaded(
        lists: lists,
        selectedList: lists.first,
      ));
    } catch (e) {
      emit(GroceryError(e.toString()));
    }
  }

  Future<void> addItem({
    required String listId,
    required String name,
    required String quantity,
    required String category,
  }) async {
    if (state is! GroceryLoaded) return;
    final current = state as GroceryLoaded;

    try {
      await _service.addItem(
          listId: listId,
          name: name,
          quantity: quantity,
          category: category
      );
      final updatedList = await _service.getGroceryListById(listId);
      emit(GroceryLoaded(
        lists: current.lists,
        selectedList: updatedList,
      ));
    } catch (e) {
      // Handle error
    }
  }

  void selectList(GroceryList list) {
    if (state is! GroceryLoaded) return;
    final current = state as GroceryLoaded;
    emit(GroceryLoaded(
      lists: current.lists,
      selectedList: list,
    ));
  }

  Future<void> toggleItem(String itemName, bool isChecked) async {
    if (state is! GroceryLoaded) return;
    final current = state as GroceryLoaded;

    final updatedItems = current.selectedList.items.map((item) {
      if (item.name == itemName) return item.copyWith(isChecked: isChecked);
      return item;
    }).toList();

    final updatedList = GroceryList(
      id: current.selectedList.id,
      planId: current.selectedList.planId,
      weekOf: current.selectedList.weekOf,
      createdAt: current.selectedList.createdAt,
      items: updatedItems,
    );

    emit(GroceryLoaded(
      lists: current.lists,
      selectedList: updatedList,
    ));

    try {
      await _service.updateItemStatus(
        listId: current.selectedList.id,
        itemName: itemName,
        isChecked: isChecked,
      );
    } catch (e) {
      emit(GroceryLoaded(
        lists: current.lists,
        selectedList: current.selectedList,
      ));
    }
  }

  Future<void> clearChecked() async {
    if (state is! GroceryLoaded) return;
    final current = state as GroceryLoaded;

    final updatedItems = current.selectedList.items
        .where((item) => !item.isChecked)
        .toList();

    final updatedList = GroceryList(
      id: current.selectedList.id,
      planId: current.selectedList.planId,
      weekOf: current.selectedList.weekOf,
      createdAt: current.selectedList.createdAt,
      items: updatedItems,
    );

    emit(GroceryLoaded(
      lists: current.lists,
      selectedList: updatedList,
    ));

    try {
      await _service.clearCheckedItems(current.selectedList.id);
    } catch (e) {
      emit(GroceryLoaded(
        lists: current.lists,
        selectedList: current.selectedList,
      ));
    }
  }

  Future<void> generateGroceryList(String planId) async {
    emit(GroceryGenerating());
    try {
      final newList = await _service.generateGroceryList(planId);
      final lists = state is GroceryLoaded
          ? [...(state as GroceryLoaded).lists, newList]
          : [newList];
      emit(GroceryLoaded(
        lists: lists,
        selectedList: newList,
      ));
    } catch (e) {
      emit(GroceryError(e.toString()));
    }
  }
}