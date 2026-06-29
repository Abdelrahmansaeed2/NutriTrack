import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_vectors.dart';
import '../cubits/api_food_search_cubit.dart';
import '../cubits/api_food_search_state.dart';
import '../widgets/page_transitions.dart';
import 'advanced_daily_dashboard_screen.dart'; // Next screen in flow

class ApiFoodSearchScreen extends StatelessWidget {
  const ApiFoodSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApiFoodSearchCubit(),
      child: const ApiFoodSearchView(),
    );
  }
}

class ApiFoodSearchView extends StatelessWidget {
  const ApiFoodSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            // Header - TopAppBar
            Container(
              color: const Color(0xFFF8F9FF),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD9E3F6),
                          shape: BoxShape.circle,
                        ),
                        // Avatar placeholder
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "NutriTrack AI",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF006C49),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.string(
                        AppVectors.icon_23,
                        width: 16,
                        height: 20,
                        colorFilter: const ColorFilter.mode(Color(0xFF006C49), BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Search & Tabs
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                children: [
                  // Search Input
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                      // The 0% opacity stroke from Figma implies no visible border or a very subtle one.
                      border: Border.all(color: const Color(0x00000000)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        SvgPicture.string(
                          AppVectors.icon_24,
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(Color(0xFF3C4A42), BlendMode.srcIn),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            onChanged: (val) => context.read<ApiFoodSearchCubit>().updateSearchQuery(val),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(0xFF121C2A),
                            ),
                            decoration: const InputDecoration(
                              hintText: "Search foods, brands...",
                              hintStyle: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF3C4A42),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Tabs
                  Container(
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: BlocBuilder<ApiFoodSearchCubit, ApiFoodSearchState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            Expanded(
                              child: _buildTab(
                                context,
                                title: "Database",
                                isSelected: state.activeTab == FoodSearchTab.database,
                                onTap: () => context.read<ApiFoodSearchCubit>().setTab(FoodSearchTab.database),
                              ),
                            ),
                            Expanded(
                              child: _buildTab(
                                context,
                                title: "Barcode",
                                isSelected: state.activeTab == FoodSearchTab.barcode,
                                onTap: () => context.read<ApiFoodSearchCubit>().setTab(FoodSearchTab.barcode),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab Content
            Expanded(
              child: BlocBuilder<ApiFoodSearchCubit, ApiFoodSearchState>(
                builder: (context, state) {
                  if (state.activeTab == FoodSearchTab.barcode) {
                    return const Center(child: Text("Barcode Scanner View"));
                  }
                  
                  return Column(
                    children: [
                      // Quick Filters
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            _buildQuickFilter(
                              context,
                              title: "All",
                              fillColor: const Color(0xFF10B981).withValues(alpha: 0.15),
                              strokeColor: const Color(0xFF10B981),
                              textColor: const Color(0xFF10B981),
                              isSelected: state.activeFilter == "All",
                            ),
                            const SizedBox(width: 8),
                            _buildQuickFilter(
                              context,
                              title: "High Protein",
                              fillColor: const Color(0xFFFF7A73).withValues(alpha: 0.15),
                              strokeColor: const Color(0xFFFF7A73),
                              textColor: const Color(0xFFB91A24),
                              isSelected: state.activeFilter == "High Protein",
                            ),
                            const SizedBox(width: 8),
                            _buildQuickFilter(
                              context,
                              title: "Keto",
                              fillColor: const Color(0xFF2170E4).withValues(alpha: 0.15),
                              strokeColor: const Color(0xFF2170E4),
                              textColor: const Color(0xFF0058BE),
                              isSelected: state.activeFilter == "Keto",
                            ),
                            const SizedBox(width: 8),
                            _buildQuickFilter(
                              context,
                              title: "Vegan",
                              fillColor: const Color(0xFFD9E3F6),
                              strokeColor: const Color(0xFFBBCABF),
                              textColor: const Color(0xFF3C4A42),
                              isSelected: state.activeFilter == "Vegan",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Results List
                      Expanded(
                        child: state.status == SearchStatus.loading
                            ? const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)))
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                                itemCount: state.results.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final item = state.results[index];
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0x0D000000)), // Faint default border
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF1F2937).withValues(alpha: 0.05),
                                          offset: const Offset(0, 4),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.title,
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF121C2A),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                item.subtitle,
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF3C4A42),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              item.calories.toString(),
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF006C49),
                                              ),
                                            ),
                                            const Text(
                                              "kcal",
                                              style: TextStyle(
                                                fontFamily: 'JetBrains Mono',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF6C7A71),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
            
            
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF8F9FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF000000).withValues(alpha: 0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  )
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF006C49) : const Color(0xFF3C4A42),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFilter(
    BuildContext context, {
    required String title,
    required Color fillColor,
    required Color strokeColor,
    required Color textColor,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => context.read<ApiFoodSearchCubit>().setFilter(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: strokeColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String title,
    required String iconVector,
    required double iconWidth,
    required double iconHeight,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF10B981) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.string(
              iconVector,
              width: iconWidth,
              height: iconHeight,
              colorFilter: ColorFilter.mode(
                isActive ? const Color(0xFF00422B) : const Color(0xFF3C4A42),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? const Color(0xFF00422B) : const Color(0xFF3C4A42),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
