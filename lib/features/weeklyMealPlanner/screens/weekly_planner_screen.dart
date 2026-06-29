import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_track/core/widgets/Header.dart';
import 'package:nutri_track/features/weeklyMealPlanner/widgets/daily_target_card.dart';
import 'package:nutri_track/features/weeklyMealPlanner/widgets/days_selector.dart';
import 'package:nutri_track/features/weeklyMealPlanner/widgets/meal_card.dart';
import '../cubits/meal_planner_cubit.dart';
import '../cubits/meal_planner_state.dart';


class WeeklyPlannerScreen extends StatefulWidget {
  const WeeklyPlannerScreen({super.key});

  @override
  State<WeeklyPlannerScreen> createState() => _WeeklyPlannerScreenState();
}

class _WeeklyPlannerScreenState extends State<WeeklyPlannerScreen> {
  static const double _targetCalories = 2450;
  static const double _targetProtein = 180;
  static const double _targetCarbs = 220;
  static const double _targetFat = 75;

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
    final today = DateTime.now();
    final startDate = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    context.read<MealPlannerCubit>().generatePlan(startDate);
  });
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
            Expanded(
              child: BlocBuilder<MealPlannerCubit, MealPlannerState>(
                builder: (context, state) {
                  if (state is MealPlannerLoading ||
                      state is MealPlannerGenerating) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF1DB574)),
                    );
                  }
                  if (state is MealPlannerError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(state.message,
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<MealPlannerCubit>()
                                .LoadLatestPlan(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1DB574),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is MealPlannerLoaded ||
                      state is MealSwapping) {
                    final plan = state is MealPlannerLoaded
                        ? state.plan
                        : (state as MealSwapping).plan;
                    final selectedDate = state is MealPlannerLoaded
                        ? state.selectedDate
                        : (state as MealSwapping).selectedDate;
                    final swappingMealType = state is MealSwapping
                        ? state.swappingMealType
                        : null;

                    final dayPlan = plan.getDay(selectedDate);

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          DaySelector(
                            dates: plan.days.keys.toList(),
                            selectedDate: selectedDate,
                            onDateSelected: (date) => context
                                .read<MealPlannerCubit>()
                                .selectDate(date),
                          ),
                          const SizedBox(height: 16),
                          if (dayPlan != null) ...[
                            DailyTargetsCard(
                              dayPlan: dayPlan,
                              targetCalories: _targetCalories,
                              targetProtein: _targetProtein,
                              targetCarbs: _targetCarbs,
                              targetFat: _targetFat,
                            ),
                            const SizedBox(height: 12),
                            MealCard(
                              mealType: 'breakfast',
                              meals: dayPlan.breakfast,
                              isSwapping: swappingMealType == 'breakfast',
                              onSwap: () => context
                                  .read<MealPlannerCubit>()
                                  .swapMeal('breakfast'),
                            ),
                            const SizedBox(height: 12),
                            MealCard(
                              mealType: 'lunch',
                              meals: dayPlan.lunch,
                              isSwapping: swappingMealType == 'lunch',
                              onSwap: () => context
                                  .read<MealPlannerCubit>()
                                  .swapMeal('lunch'),
                            ),
                            const SizedBox(height: 12),
                            MealCard(
                              mealType: 'dinner',
                              meals: dayPlan.dinner,
                              isSwapping: swappingMealType == 'dinner',
                              onSwap: () => context
                                  .read<MealPlannerCubit>()
                                  .swapMeal('dinner'),
                            ),
                            const SizedBox(height: 12),
                            MealCard(
                              mealType: 'snacks',
                              meals: dayPlan.snacks,
                              isSwapping: swappingMealType == 'snacks',
                              onSwap: () => context
                                  .read<MealPlannerCubit>()
                                  .swapMeal('snacks'),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}