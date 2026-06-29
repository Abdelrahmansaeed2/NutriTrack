import 'package:equatable/equatable.dart';
import '../../features/tracking/models/grocery_list_model.dart';

enum GroceryStatus { initial, loading, loaded, error }

class GroceryListState extends Equatable {
  final GroceryStatus status;
  final List<GroceryList> lists;
  final String? activeListId;
  final String? errorMessage;

  const GroceryListState({
    this.status = GroceryStatus.initial,
    this.lists = const [],
    this.activeListId,
    this.errorMessage,
  });

  /// The active list for display (most recent or first)
  GroceryList? get activeList {
    if (lists.isEmpty) return null;
    if (activeListId != null) {
      try {
        return lists.firstWhere((l) => l.id == activeListId);
      } catch (_) {}
    }
    return lists.first;
  }

  int get totalItems => activeList?.totalItems ?? 0;
  int get checkedItems => activeList?.checkedItems ?? 0;
  int get remainingItems => totalItems - checkedItems;
  double get progressPercentage =>
      totalItems == 0 ? 0.0 : checkedItems / totalItems;

  GroceryListState copyWith({
    GroceryStatus? status,
    List<GroceryList>? lists,
    String? activeListId,
    String? errorMessage,
  }) {
    return GroceryListState(
      status: status ?? this.status,
      lists: lists ?? this.lists,
      activeListId: activeListId ?? this.activeListId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, lists, activeListId, errorMessage];
}
