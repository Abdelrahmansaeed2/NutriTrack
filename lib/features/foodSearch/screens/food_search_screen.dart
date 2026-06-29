import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_track/core/widgets/Header.dart';
import 'package:nutri_track/features/foodSearch/widgets/food_search_results.dart';
import '../cubits/food_search_cubit.dart';
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
            const Header(),
            _buildSearchBar(),
            const SizedBox(height: 12),
            FilterChipRow(
              tags: _tags,
              selectedTag: _selectedTag,
              onTagSelected: _onTagSelected,
            ),
            const SizedBox(height: 8),
            Expanded(child: FoodSearchResults(
                searchQuery: _searchController.text,
              ),),
          ],
        ),
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
}