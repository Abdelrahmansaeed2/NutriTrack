import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_vectors.dart';
import '../cubits/weekly_planner_cubit.dart';
import '../cubits/weekly_planner_state.dart';
import '../widgets/page_transitions.dart';
import 'dynamic_food_detail_screen.dart'; // Next screen in flow

class AiWeeklyCalendarScreen extends StatelessWidget {
  const AiWeeklyCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeeklyPlannerCubit(),
      child: const AiWeeklyCalendarView(),
    );
  }
}

class AiWeeklyCalendarView extends StatelessWidget {
  const AiWeeklyCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: BlocListener<WeeklyPlannerCubit, WeeklyPlannerState>(
          listenWhen: (previous, current) => previous.isSwapping != current.isSwapping,
          listener: (context, state) {
            if (state.isSwapping) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("AI is calculating a meal swap..."),
                  duration: Duration(seconds: 1),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            }
          },
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
                          AppVectors.icon_40, // Settings/Calendar Icon
                          width: 16,
                          height: 20,
                          colorFilter: const ColorFilter.mode(Color(0xFF006C49), BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Main Header Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Weekly Planner",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF121C2A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Optimize your macros and prep your meals for the week.",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF3C4A42),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Section - Horizontal Day Picker
                            SizedBox(
                              height: 85,
                              child: BlocBuilder<WeeklyPlannerCubit, WeeklyPlannerState>(
                                builder: (context, state) {
                                  final baseDate = DateTime(2023, 6, 12); // Starting Monday
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 7,
                                    itemBuilder: (context, index) {
                                      final date = baseDate.add(Duration(days: index));
                                      final isSelected = date.day == state.selectedDate.day;
                                      return _buildDayPickerItem(
                                        context,
                                        date: date,
                                        isSelected: isSelected,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Section - Macro Summary (Daily)
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: const Color(0xFFD9E3F6)),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1F2937).withValues(alpha: 0.05),
                                    offset: const Offset(0, 4),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Daily Targets",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF121C2A),
                                        ),
                                      ),
                                      const Text(
                                        "2,450 kcal",
                                        style: TextStyle(
                                          fontFamily: 'JetBrains Mono',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF006C49),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  _buildPlannerMacroBar("Protein", "180g", const Color(0xFF2170E4), 0.7),
                                  const SizedBox(height: 16),
                                  _buildPlannerMacroBar("Carbs", "220g", const Color(0xFFFF7A73), 0.8),
                                  const SizedBox(height: 16),
                                  _buildPlannerMacroBar("Fats", "75g", const Color(0xFF6C7A71), 0.6),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Section - Meal Cards List
                            BlocBuilder<WeeklyPlannerCubit, WeeklyPlannerState>(
                              builder: (context, state) {
                                // Add a subtle opacity animation when swapping
                                return AnimatedOpacity(
                                  opacity: state.isSwapping ? 0.5 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Column(
                                    children: [
                                      _buildMealCard(
                                        context,
                                        mealType: "Breakfast",
                                        kcal: "450 kcal",
                                        recipeName: "Greek Yogurt Berry Bowl",
                                        macros: "P: 35g  C: 45g  F: 12g",
                                        iconVector: AppVectors.icon_47,
                                        iconColor: const Color(0xFF2170E4),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildMealCard(
                                        context,
                                        mealType: "Lunch",
                                        kcal: "750 kcal",
                                        recipeName: "Grilled Chicken Quinoa Salad",
                                        macros: "P: 55g  C: 65g  F: 22g",
                                        iconVector: AppVectors.icon_49,
                                        iconColor: const Color(0xFF006C49),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildMealCard(
                                        context,
                                        mealType: "Dinner",
                                        kcal: "650 kcal",
                                        recipeName: "Salmon with Roasted Veggies",
                                        macros: "P: 45g  C: 30g  F: 25g",
                                        iconVector: AppVectors.icon_51,
                                        iconColor: const Color(0xFFFF7A73),
                                      ),
                                      const SizedBox(height: 32),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayPickerItem(
    BuildContext context, {
    required DateTime date,
    required bool isSelected,
  }) {
    final dayStr = DateFormat('E').format(date).toUpperCase();
    final dateStr = date.day.toString();

    return GestureDetector(
      onTap: () => context.read<WeeklyPlannerCubit>().selectDate(date),
      child: Container(
        width: 64,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? null : Border.all(color: const Color(0xFFD9E3F6)),
          boxShadow: isSelected
              ? [
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
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayStr,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF00422B) : const Color(0xFF3C4A42),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateStr,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF00422B) : const Color(0xFF121C2A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlannerMacroBar(String title, String values, Color progressColor, double percentage) {
    return Row(
      children: [
        SizedBox(
          width: 55,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF3C4A42),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFD9E3F6), // Universal track background for Planner
              borderRadius: BorderRadius.circular(9999),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    Container(
                      width: constraints.maxWidth * percentage,
                      decoration: BoxDecoration(
                        color: progressColor,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 35,
          child: Text(
            values,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF121C2A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard(
    BuildContext context, {
    required String mealType,
    required String kcal,
    required String recipeName,
    required String macros,
    required String iconVector,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD9E3F6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F2937).withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.string(
                      iconVector,
                      width: 19,
                      height: 19,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      mealType,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF121C2A),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6EEFF),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    kcal,
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
          
          // Recipe Image & Info Block
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Image Placeholder
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9E3F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipeName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF121C2A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        macros,
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
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action Button
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFD9E3F6))),
            ),
            child: InkWell(
              onTap: () {
                context.read<WeeklyPlannerCubit>().swapMeal(
                  DateTime.now().toIso8601String().split('T').first,
                  'lunch',
                );
                // Optionally navigate to details
                context.go('/home');
              },
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    "Swap Meal",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF006C49),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
