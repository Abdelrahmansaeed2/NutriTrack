import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nutri_track/core/network/api_client.dart';
import 'package:nutri_track/core/widgets/Header.dart';
import 'package:nutri_track/features/custom%20recipe/screeens/custom_recipe_screen.dart';
import '../models/daily_dashboard_models.dart';
import '../../food details/screens/food_detail_screen.dart';
import '../../food details/models/food_detail_models.dart';
import '../../../core/theme/app_theme.dart';
import '../../waterTracking/screens/water_tracking_screen.dart';
import '../cubits/daily_dashboard_cubit.dart';
import '../cubits/daily_dashboard_state.dart';
import '../services/daily_dashboard_service.dart';

class DailyDashboardScreen extends StatefulWidget {
  const DailyDashboardScreen({super.key});

  @override
  State<DailyDashboardScreen> createState() => _DailyDashboardScreenState();
}

class _DailyDashboardScreenState extends State<DailyDashboardScreen> {
  late final List<DateTime> _dates;
  int _selectedIndex = 5; // Default to today (last item in the 6-day list)

  @override
  void initState() {
    super.initState();
    _dates = List.generate(6, (index) {
      return DateTime.now().subtract(Duration(days: 5 - index));
    });
  }

  String get _selectedDateStr => DateFormat('yyyy-MM-dd').format(_dates[_selectedIndex]);

  List<MacroData> _buildMacros(ColorScheme cs, Map<String, dynamic> totals, Map<String, dynamic> targets) {
    final proteinCurrent = (totals['protein'] as num?)?.toInt() ?? 0;
    final proteinTarget = (targets['proteinGrams'] as num?)?.toInt() ?? 150;
    final carbsCurrent = (totals['carbs'] as num?)?.toInt() ?? 0;
    final carbsTarget = (targets['carbsGrams'] as num?)?.toInt() ?? 200;
    final fatCurrent = (totals['fat'] as num?)?.toInt() ?? 0;
    final fatTarget = (targets['fatGrams'] as num?)?.toInt() ?? 70;

    return [
      MacroData(
        label: 'Protein',
        current: proteinCurrent,
        target: proteinTarget,
        barColor: cs.tertiary,
        trackColor: cs.tertiaryContainer,
      ),
      MacroData(
        label: 'Carbs',
        current: carbsCurrent,
        target: carbsTarget,
        barColor: cs.secondary,
        trackColor: cs.secondaryContainer,
      ),
      MacroData(
        label: 'Fats',
        current: fatCurrent,
        target: fatTarget,
        barColor: cs.primary,
        trackColor: AppTheme.primaryBrandColor.withValues(alpha: 0.2),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final List<DayItem> dayItems = _dates.asMap().entries.map((entry) {
      final i = entry.key;
      final date = entry.value;
      final dayName = DateFormat('E').format(date).toUpperCase();
      return DayItem(dayName, date.day, isActive: i == _selectedIndex);
    }).toList();

    return BlocProvider(
      create: (_) => DailyDashboardCubit(DailyDashboardService(ApiClient.instance.dio))
        ..loadDailyLog(_selectedDateStr),
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: Column(
            children: [
              Header(),
              Expanded(
                child: BlocBuilder<DailyDashboardCubit, DailyDashboardState>(
                  builder: (context, state) {
                    if (state is DailyDashboardLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DailyDashboardError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.read<DailyDashboardCubit>().loadDailyLog(_selectedDateStr),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is DailyDashboardLoaded) {
                      final log = state.logData;
                      final totals = log['totals'] as Map<String, dynamic>? ?? {};
                      final targets = log['targets'] as Map<String, dynamic>? ?? {};
                      final mealsMap = log['meals'] as Map<String, dynamic>? ?? {};
                      
                      final breakfastList = mealsMap['breakfast'] as List<dynamic>? ?? [];
                      final lunchList = mealsMap['lunch'] as List<dynamic>? ?? [];
                      final dinnerList = mealsMap['dinner'] as List<dynamic>? ?? [];
                      final snacksList = mealsMap['snacks'] as List<dynamic>? ?? [];

                      List<FoodEntry> mapToFoodEntries(List<dynamic> list) {
                        return list.map((item) {
                          final name = item['name'] as String? ?? 'Unknown';
                          final quantity = item['quantity']?.toString() ?? '1 serving';
                          final calories = (item['calories'] as num?)?.toInt() ?? 0;
                          return FoodEntry(name, quantity, calories);
                        }).toList();
                      }

                      int calculateTotalKcal(List<dynamic> list) {
                        return list.fold(0, (sum, item) => sum + ((item['calories'] as num?)?.toInt() ?? 0));
                      }

                      final mealSections = [
                        MealSection(
                          title: 'Breakfast',
                          icon: Icons.coffee,
                          totalKcal: calculateTotalKcal(breakfastList),
                          entries: mapToFoodEntries(breakfastList),
                          isEmpty: breakfastList.isEmpty,
                        ),
                        MealSection(
                          title: 'Lunch',
                          icon: Icons.restaurant,
                          totalKcal: calculateTotalKcal(lunchList),
                          entries: mapToFoodEntries(lunchList),
                          isEmpty: lunchList.isEmpty,
                        ),
                        MealSection(
                          title: 'Dinner',
                          icon: Icons.dinner_dining,
                          totalKcal: calculateTotalKcal(dinnerList),
                          entries: mapToFoodEntries(dinnerList),
                          isEmpty: dinnerList.isEmpty,
                        ),
                        MealSection(
                          title: 'Snacks',
                          icon: Icons.cookie,
                          totalKcal: calculateTotalKcal(snacksList),
                          entries: mapToFoodEntries(snacksList),
                          isEmpty: snacksList.isEmpty,
                        ),
                      ];

                      final waterData = log['waterIntake'] as Map<String, dynamic>? ?? {};
                      final waterTotal = (waterData['totalMl'] as num?)?.toInt() ?? 0;
                      final waterGoal = (waterData['goalMl'] as num?)?.toInt() ?? 3000;

                      final calorieCurrent = (totals['calories'] as num?)?.toInt() ?? 0;
                      final calorieTarget = (targets['dailyCalories'] as num?)?.toInt() ?? 2000;

                      return RefreshIndicator(
                        onRefresh: () => context.read<DailyDashboardCubit>().loadDailyLog(_selectedDateStr),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              _DateSelector(
                                days: dayItems,
                                selectedIndex: _selectedIndex,
                                onSelected: (i) {
                                  setState(() => _selectedIndex = i);
                                  context.read<DailyDashboardCubit>().loadDailyLog(_selectedDateStr);
                                },
                              ),
                              const SizedBox(height: 24),
                              _MacroDashboard(
                                currentCalories: calorieCurrent,
                                targetCalories: calorieTarget,
                                macros: _buildMacros(cs, totals, targets),
                              ),
                              const SizedBox(height: 24),
                              _WaterCard(
                                totalMl: waterTotal,
                                goalMl: waterGoal,
                                dateStr: _selectedDateStr,
                                onBack: () {
                                  context.read<DailyDashboardCubit>().loadDailyLog(_selectedDateStr);
                                },
                              ),
                              const SizedBox(height: 24),
                              _DailyLog(
                                meals: mealSections,
                                dateStr: _selectedDateStr,
                              ),
                            ],
                          ),
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
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  final List<DayItem> days;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  const _DateSelector({required this.days, required this.selectedIndex, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final day = days[i];
          final isActive = i == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              decoration: BoxDecoration(
                color: isActive ? cs.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isActive
                    ? [BoxShadow(color: cs.primary.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 2))]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(day.dayName,
                      style: TextStyle(
                        fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: isActive ? cs.onPrimary : cs.onSurfaceVariant,
                      )),
                  const SizedBox(height: 4),
                  Text('${day.dayNumber}',
                      style: TextStyle(
                        fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600,
                        color: isActive ? cs.onPrimary : cs.onSurface,
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MacroDashboard extends StatelessWidget {
  final int currentCalories;
  final int targetCalories;
  final List<MacroData> macros;
  const _MacroDashboard({
    required this.currentCalories,
    required this.targetCalories,
    required this.macros,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: const Color(0xFF1F2937).withValues(alpha: 0.05),
              blurRadius: 12, offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _CalorieRing(current: currentCalories, target: targetCalories),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: macros.map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _MacroBar(data: m),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalorieRing extends StatelessWidget {
  final int current;
  final int target;
  const _CalorieRing({required this.current, required this.target});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final progress = target > 0 ? (current / target).clamp(0.0, 1.5) : 0.0;
    return SizedBox(
      width: 140, height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(140, 140),
            painter: _RingPainter(
              progress: progress,
              progressColor: cs.primary,
              trackColor: cs.surfaceContainerHigh,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                NumberFormat('#,###').format(current),
                style: TextStyle(fontFamily: 'Inter', fontSize: 24,
                    fontWeight: FontWeight.w700, color: cs.onSurface),
              ),
              Text('/ $target kcal',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 11,
                      fontWeight: FontWeight.w500, letterSpacing: 0.5,
                      color: cs.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color trackColor;
  const _RingPainter({required this.progress, required this.progressColor, required this.trackColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = (size.width / 2) - 10;
    const strokeWidth = 11.0;
    canvas.drawCircle(Offset(cx, cy), radius,
        Paint()..color = trackColor..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth..strokeCap = StrokeCap.round);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      -math.pi / 2, 2 * math.pi * progress, false,
      Paint()..color = progressColor..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.progressColor != progressColor;
}

class _MacroBar extends StatelessWidget {
  final MacroData data;
  const _MacroBar({required this.data});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(data.label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14)),
            Text('${data.current}g / ${data.target}g',
                style: TextStyle(fontFamily: 'Inter', fontSize: 11,
                    fontWeight: FontWeight.w500, letterSpacing: 0.5,
                    color: cs.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: Stack(
            children: [
              Container(height: 10, color: data.trackColor),
              FractionallySizedBox(
                widthFactor: data.progress,
                child: Container(height: 10, color: data.barColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DailyLog extends StatelessWidget {
  final List<MealSection> meals;
  final String dateStr;
  const _DailyLog({required this.meals, required this.dateStr});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: meals.map((m) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _MealCard(meal: m, dateStr: dateStr),
        )).toList(),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealSection meal;
  final String dateStr;
  const _MealCard({required this.meal, required this.dateStr});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Opacity(
      opacity: meal.isEmpty ? 0.6 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: const Color(0xFF1F2937).withValues(alpha: 0.05),
              blurRadius: 12, offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(meal.icon, color: cs.primary, size: 20),
                const SizedBox(width: 8),
                Text(meal.title, style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text(
                  meal.isEmpty ? (meal.recommendation ?? '0 kcal') : '${meal.totalKcal} kcal',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 11,
                      fontWeight: FontWeight.w500, letterSpacing: 0.5,
                      color: cs.onSurfaceVariant),
                ),
                const SizedBox(width: 8),
                _AddButton(dateStr: dateStr, meal: meal),
              ],
            ),
            if (meal.entries.isNotEmpty) ...[
              const SizedBox(height: 8),
              Divider(color: cs.surfaceContainer, height: 1),
              const SizedBox(height: 8),
              ...meal.entries.asMap().entries.map((e) {
                final isLast = e.key == meal.entries.length - 1;
                return Column(children: [
                  _FoodEntryRow(
                    entry: e.value,
                    index: e.key,
                    mealType: meal.title,
                    dateStr: dateStr,
                  ),
                  if (!isLast) Divider(color: cs.surfaceContainer, height: 1, thickness: 1),
                ]);
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final String dateStr;
  final MealSection meal;
  const _AddButton({required this.dateStr, required this.meal});

  void _showOptions(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              // Create Recipe
              ListTile(
                leading: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.menu_book_rounded, color: cs.primary),
                ),
                title: Text('Create Recipe',
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text('Build your own custom recipe',
                    style: Theme.of(context).textTheme.labelSmall),
                onTap: () {
                  // Capture these BEFORE popping the bottom sheet,
                  // because the context becomes invalid after pop.
                  final nav = Navigator.of(context);
                  final cubit = context.read<DailyDashboardCubit>();
                  nav.pop(); // close bottom sheet
                  nav.push(MaterialPageRoute(
                    builder: (_) => CustomRecipeBuilderScreen(
                      date: dateStr,
                      mealType: meal.title.toLowerCase(),
                    ),
                  )).then((_) {
                    cubit.loadDailyLog(dateStr);
                  });
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(99),
      child: InkWell(
        borderRadius: BorderRadius.circular(99),
        onTap: () => _showOptions(context),
        child: SizedBox(
          width: 32, height: 32,
          child: Icon(Icons.add, color: cs.primary, size: 18),
        ),
      ),
    );
  }
}

class _FoodEntryRow extends StatelessWidget {
  final FoodEntry entry;
  final int index;
  final String mealType;
  final String dateStr;
  const _FoodEntryRow({
    required this.entry,
    required this.index,
    required this.mealType,
    required this.dateStr,
  });

  void _openDetail(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => FoodDetailScreen(
        food: FoodDetail(
          name: entry.name,
          subtitle: entry.detail,
          category: 'High Protein',
          imageUrl: 'assets/images/salmon.webp',
          totalKcal: entry.kcal,
          servingGrams: 150,
          macros: const [
            MacroNutrient(label: 'Protein', grams: 34, percentage: 0.60),
            MacroNutrient(label: 'Fat',     grams: 18, percentage: 0.30),
            MacroNutrient(label: 'Carbs',   grams: 0,  percentage: 0.10),
          ],
          micronutrients: const [
            MicronutrientTag('Vit D'),
            MicronutrientTag('Omega-3'),
            MicronutrientTag('B12'),
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _openDetail(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(entry.detail, style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text('${entry.kcal} kcal',
                style: TextStyle(fontFamily: 'Inter', fontSize: 11,
                    fontWeight: FontWeight.w500, letterSpacing: 0.5,
                    color: cs.onSurface)),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            onPressed: () {
              context.read<DailyDashboardCubit>().removeMealItem(dateStr, mealType, index);
            },
          ),
        ],
      ),
    );
  }
}

class _WaterCard extends StatelessWidget {
  final int totalMl;
  final int goalMl;
  final String dateStr;
  final VoidCallback onBack;
  const _WaterCard({
    required this.totalMl,
    required this.goalMl,
    required this.dateStr,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final progress = goalMl > 0 ? (totalMl / goalMl).clamp(0.0, 1.0) : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WaterTrackingScreen(initialDateStr: dateStr),
            ),
          );
          onBack();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1F2937).withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: cs.secondary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.water_drop, color: cs.secondary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Water Intake',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: Stack(children: [
                        Container(height: 6,
                            color: cs.secondary.withValues(alpha: 0.1)),
                        FractionallySizedBox(
                          widthFactor: progress,
                          child: Container(height: 6, color: cs.secondary),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 4),
                    Text('${(totalMl / 1000).toStringAsFixed(1)}L of ${(goalMl / 1000).toStringAsFixed(1)}L',
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}