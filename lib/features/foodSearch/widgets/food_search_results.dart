import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_track/features/food%20details/models/food_detail_models.dart';
import 'package:nutri_track/features/food%20details/screens/food_detail_screen.dart';
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
                onTap: () {
                  final detail = FoodDetail(
                    id: food.id,
                    name: food.name,
                    subtitle: food.brand ?? food.servingSize ?? '1 serving',
                    category: food.tags.isNotEmpty ? food.tags.first : 'General',
                    imageUrl: 'assets/images/salmon.webp',
                    totalKcal: food.calories.toInt(),
                    servingGrams: 100,
                    macros: [
                      MacroNutrient(label: 'Protein', grams: food.macros.protein, percentage: 0.3),
                      MacroNutrient(label: 'Carbs', grams: food.macros.carbs, percentage: 0.4),
                      MacroNutrient(label: 'Fat', grams: food.macros.fat, percentage: 0.3),
                    ],
                    micronutrients: const [
                      MicronutrientTag('High Quality'),
                    ],
                  );
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => FoodDetailScreen(food: detail),
                  ));
                },
              );
            },
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }
}