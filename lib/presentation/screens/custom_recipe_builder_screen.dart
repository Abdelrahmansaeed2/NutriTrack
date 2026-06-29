import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_vectors.dart';
import '../cubits/recipe_builder_cubit.dart';
import '../cubits/recipe_builder_state.dart';

class CustomRecipeBuilderScreen extends StatelessWidget {
  const CustomRecipeBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecipeBuilderCubit(),
      child: const CustomRecipeBuilderView(),
    );
  }
}

class CustomRecipeBuilderView extends StatelessWidget {
  const CustomRecipeBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            // Header - Custom Top App Bar
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FF),
                border: Border(bottom: BorderSide(color: Color(0xFFD9E3F6))),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.string(
                        AppVectors.icon_54, // Back Arrow
                        width: 16,
                        height: 16,
                        colorFilter: const ColorFilter.mode(Color(0xFF3C4A42), BlendMode.srcIn),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Builder",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF121C2A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 32), // Balance for centering
                ],
              ),
            ),
            
            // Main Canvas - Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hero / Title Input
                      const Text(
                        "RECIPE NAME",
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3C4A42),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF000000).withValues(alpha: 0.05),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (val) => context.read<RecipeBuilderCubit>().updateName(val),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF121C2A),
                          ),
                          decoration: const InputDecoration(
                            hintText: "e.g. Protein Packed Oats",
                            hintStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFBBCABF),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Ingredients List Section
                      BlocBuilder<RecipeBuilderCubit, RecipeBuilderState>(
                        builder: (context, state) {
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1F2937).withValues(alpha: 0.05),
                                  offset: const Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Header
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color(0xFFD9E3F6))),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Ingredients",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF121C2A),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE6EEFF),
                                          borderRadius: BorderRadius.circular(9999),
                                        ),
                                        child: Text(
                                          "${state.ingredients.length} Items",
                                          style: const TextStyle(
                                            fontFamily: 'JetBrains Mono',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF3C4A42),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // List Items
                                ...state.ingredients.map((item) => _buildIngredientItem(context, item)),
                                // Add Button
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: GestureDetector(
                                    onTap: () => context.read<RecipeBuilderCubit>().addIngredient(
                                      RecipeIngredient(
                                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                                        name: 'New Ingredient',
                                        amount: '100g',
                                        kcal: 0,
                                        protein: 0,
                                        carbs: 0,
                                        fat: 0,
                                      ),
                                    ),
                                    child: Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: const Color(0xFF10B981), width: 1.5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.string(
                                            AppVectors.icon_67, // Fallback to plus icon if available, assumed to be here, but we can use icon_58 if we must
                                            width: 14,
                                            height: 14,
                                            colorFilter: const ColorFilter.mode(Color(0xFF10B981), BlendMode.srcIn),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "Add Ingredient",
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF10B981),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            
            // Sticky Bottom Footer (Macros & Actions)
            BlocBuilder<RecipeBuilderCubit, RecipeBuilderState>(
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    border: const Border(top: BorderSide(color: Color(0xFFD9E3F6))),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1F2937).withValues(alpha: 0.08),
                        offset: const Offset(0, 8),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Cumulative Macros
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "TOTAL CALORIES",
                                style: TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF3C4A42),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    state.totalKcal.toString(),
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF121C2A),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "kcal",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF3C4A42),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              _buildMacroTag("PRO", "${state.totalProtein}g", const Color(0xFFFFB3AD), const Color(0xFFEF4444)),
                              const SizedBox(width: 8),
                              _buildMacroTag("CARB", "${state.totalCarbs}g", const Color(0xFFADC6FF), const Color(0xFF3B82F6)),
                              const SizedBox(width: 8),
                              _buildMacroTag("FAT", "${state.totalFat}g", const Color(0xFFFEF08A), const Color(0xFFEAB308)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Save Action
                      GestureDetector(
                        onTap: state.isValid ? () {
                          // Save action logic here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Recipe Saved!'), backgroundColor: Color(0xFF10B981)),
                          );
                        } : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 56,
                          decoration: BoxDecoration(
                            color: state.isValid ? const Color(0xFF10B981) : const Color(0xFFBBCABF),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: state.isValid ? [
                              BoxShadow(
                                color: const Color(0xFF000000).withValues(alpha: 0.10),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                              BoxShadow(
                                color: const Color(0xFF000000).withValues(alpha: 0.10),
                                offset: const Offset(0, 4),
                                blurRadius: 6,
                              ),
                            ] : [],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.string(
                                AppVectors.icon_64, // Save icon
                                width: 18,
                                height: 18,
                                colorFilter: const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Save Recipe",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientItem(BuildContext context, RecipeIngredient item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF121C2A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.amount,
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3C4A42),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                "${item.kcal} kcal",
                style: const TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF121C2A),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => context.read<RecipeBuilderCubit>().removeIngredient(item.id),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.string(
                    AppVectors.icon_65, // Delete Trash Icon
                    width: 10,
                    height: 10,
                    colorFilter: const ColorFilter.mode(Color(0xFFBA1A1A), BlendMode.srcIn),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroTag(String label, String value, Color bgColor, Color iconColor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF3C4A42),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.only(left: 4, right: 8, top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dummy circle placeholder for SVG
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: iconColor, width: 2),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF121C2A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
