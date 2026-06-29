import 'package:equatable/equatable.dart';

enum FoodSearchTab { database, barcode }
enum SearchStatus { initial, loading, success, failure }

class FoodItem extends Equatable {
  final String title;
  final String subtitle;
  final int calories;

  const FoodItem({
    required this.title,
    required this.subtitle,
    required this.calories,
  });

  @override
  List<Object?> get props => [title, subtitle, calories];
}

class ApiFoodSearchState extends Equatable {
  final FoodSearchTab activeTab;
  final String searchQuery;
  final String activeFilter;
  final SearchStatus status;
  final List<FoodItem> results;

  const ApiFoodSearchState({
    this.activeTab = FoodSearchTab.database,
    this.searchQuery = '',
    this.activeFilter = 'All',
    this.status = SearchStatus.initial,
    this.results = const [
      FoodItem(title: "Grilled Chicken Breast", subtitle: "Kirkland Signature • 4 oz", calories: 130),
      FoodItem(title: "Greek Yogurt, Plain Nonfat", subtitle: "Chobani • 1 cup", calories: 120),
      FoodItem(title: "Almonds, Roasted & Salted", subtitle: "Blue Diamond • 1 oz", calories: 170),
    ],
  });

  ApiFoodSearchState copyWith({
    FoodSearchTab? activeTab,
    String? searchQuery,
    String? activeFilter,
    SearchStatus? status,
    List<FoodItem>? results,
  }) {
    return ApiFoodSearchState(
      activeTab: activeTab ?? this.activeTab,
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilter: activeFilter ?? this.activeFilter,
      status: status ?? this.status,
      results: results ?? this.results,
    );
  }

  @override
  List<Object?> get props => [activeTab, searchQuery, activeFilter, status, results];
}
