import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/food_search_cubit.dart';
import '../cubits/food_search_state.dart';
import '../widgets/food_card.dart';
import '../widgets/filter_chip_row.dart';

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _selectedTag = 'all';

  final List<String> _tags = ['All', 'High Protein', 'Keto', 'Vegan'];
  
  @override
  void initState() {
    super.initState();
    context.read<FoodSearchCubit>().loadFavourites();
    context.read<FoodSearchCubit>().searchFoods(query: '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<FoodSearchCubit>().searchFoods(
            query: query,
            selectedTag: _selectedTag,
          );
    });
  }

  void _onTagSelected(String tag) {
    setState(() => _selectedTag = tag.toLowerCase() == 'all' ? 'all' : tag);
    context.read<FoodSearchCubit>().searchFoods(
          query: _searchController.text,
          selectedTag: _selectedTag,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            const SizedBox(height: 12),
            FilterChipRow(
              tags: _tags,
              selectedTag: _selectedTag,
              onTagSelected: _onTagSelected,
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 18,
              backgroundColor: Color(0xFF1DB574),
  child: Icon(Icons.person, color: Colors.white, size: 18)
              ),
              const SizedBox(width: 8),
              Text(
                'NutriTrack AI',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF1DB574),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            color: const Color(0xFF1DB574),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search foods, brands...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    return BlocBuilder<FoodSearchCubit, FoodSearchState>(
      builder: (context, state) {
        if (state is FoodSearchInitial) {
          return _buildEmptyState(
            icon: Icons.search,
            message: 'Search for a food to get started',
          );
        }
        if (state is FoodSearchLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1DB574)));
        }
        if (state is FoodSearchError) {
          return _buildEmptyState(
            icon: Icons.error_outline,
            message: state.message,
            isError: true,
          );
        }
        if (state is FoodSearchLoaded) {
          if (state.foods.isEmpty) {
            return _buildEmptyState(
              icon: Icons.search_off,
              message: 'No foods found for "${_searchController.text}"',
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

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    bool isError = false,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: isError ? Colors.red : Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}