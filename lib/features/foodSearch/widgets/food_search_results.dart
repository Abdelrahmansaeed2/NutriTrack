import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/food_search_cubit.dart';
import '../cubits/food_search_state.dart';
import 'food_card.dart';
import 'food_search_empty_state.dart'; // Extracted below

class FoodSearchResults extends StatelessWidget {
  final String searchQuery;

  const FoodSearchResults({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodSearchCubit, FoodSearchState>(
      builder: (context, state) {
        if (state is FoodSearchInitial) {
          return const FoodSearchEmptyState(
            icon: Icons.search,
            message: 'Search for a food to get started',
          );
        }
        
        if (state is FoodSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1DB574)),
          );
        }
        
        if (state is FoodSearchError) {
          return FoodSearchEmptyState(
            icon: Icons.error_outline,
            message: state.message,
            isError: true,
          );
        }
        
        if (state is FoodSearchLoaded) {
          if (state.foods.isEmpty) {
            return FoodSearchEmptyState(
              icon: Icons.search_off,
              message: 'No foods found for "$searchQuery"',
            );
          }
          
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: state.foods.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final food = state.foods[index];
              return FoodCard(
                food: food,
                isFavorite: state.isFavourite(food.id),
                onFavoriteTap: () =>
                    context.read<FoodSearchCubit>().toggleFavorite(food.id),
              );
            },
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }
}