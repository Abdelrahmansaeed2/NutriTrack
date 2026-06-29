import '../models/grocery_list_model.dart';

abstract class GroceryState {}

class GroceryInitial extends GroceryState {}

class GroceryLoading extends GroceryState {}

class GroceryLoaded extends GroceryState {
  final List<GroceryList> lists;
  final GroceryList selectedList;

  GroceryLoaded({
    required this.lists,
    required this.selectedList,
  });
}

class GroceryNoListButPlanExists extends GroceryState {
  final String planId;
  GroceryNoListButPlanExists(this.planId);
}

class GroceryGenerating extends GroceryState {}

class GroceryError extends GroceryState {
  final String message;
  GroceryError(this.message);
}