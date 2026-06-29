import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nutri_track/core/widgets/Header.dart';
import 'package:nutri_track/features/custom%20recipe/screeens/custom_recipe_screen.dart';
import '../models/daily_dashboard_models.dart';
import '../../food details/screens/food_detail_screen.dart';
import '../../food details/models/food_detail_models.dart';
import '../../../core/theme/app_theme.dart';
import '../../waterTracking/screens/water_tracking_screen.dart';


class DailyDashboardScreen extends StatefulWidget {
  const DailyDashboardScreen({super.key});

  @override
  State<DailyDashboardScreen> createState() => _DailyDashboardScreenState();
}

class _DailyDashboardScreenState extends State<DailyDashboardScreen> {
  int _selectedDay = 2;
  int _selectedNav = 0;

  final List<DayItem> _days = const [
    DayItem('MON', 12),
    DayItem('TUE', 13),
    DayItem('WED', 14, isActive: true),
    DayItem('THU', 15),
    DayItem('FRI', 16),
    DayItem('SAT', 17),
  ];

  List<MacroData> _buildMacros(ColorScheme cs) => [
    MacroData(label: 'Protein', current: 120, target: 150,
        barColor: cs.tertiary,  trackColor: cs.tertiaryContainer),
    MacroData(label: 'Carbs',   current: 210, target: 250,
        barColor: cs.secondary, trackColor: cs.secondaryContainer),
    MacroData(label: 'Fats',    current: 54,  target: 70,
        barColor: cs.primary,   trackColor: AppTheme.primaryBrandColor),
  ];

  final List<MealSection> _meals = const [
    MealSection(
      title: 'Breakfast', icon: Icons.coffee, totalKcal: 350,
      entries: [FoodEntry('Boiled Eggs and Barley Bread', '2 Eggs, 1 Slice', 350)],
    ),
    MealSection(
      title: 'Lunch', icon: Icons.restaurant, totalKcal: 650,
      entries: [
        FoodEntry('Grilled Chicken Salad', '150g Chicken, Mixed Greens', 420),
        FoodEntry('Quinoa Bowl', '1 Cup', 230),
      ],
    ),
    MealSection(
      title: 'Dinner', icon: Icons.dinner_dining, totalKcal: 0,
      isEmpty: true, recommendation: 'Recommend: ~600',
    ),
    MealSection(
      title: 'Snacks', icon: Icons.cookie, totalKcal: 0, isEmpty: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _DateSelector(
                      days: _days,
                      selectedIndex: _selectedDay,
                      onSelected: (i) => setState(() => _selectedDay = i),
                    ),
                    const SizedBox(height: 24),
                    _MacroDashboard(macros: _buildMacros(cs)),
                    const SizedBox(height: 24),
                    _WaterCard(),
                    const SizedBox(height: 24),
                    _DailyLog(meals: _meals),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}

class _TopAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: cs.primaryContainer, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/avatar.jpeg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: cs.primaryContainer,
                  child: Icon(Icons.person, color: cs.onPrimary, size: 20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text('NutriTrack AI',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: cs.primary, letterSpacing: -0.3,
              )),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(99),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.notifications_outlined,
                    color: cs.onSurfaceVariant, size: 24),
              ),
            ),
          ),
        ],
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
  final List<MacroData> macros;
  const _MacroDashboard({required this.macros});

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
           const _CalorieRing(current: 1850, target: 2400),
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
    final progress = current / target;
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
              Text('1,850',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 24,
                      fontWeight: FontWeight.w700, color: cs.onSurface)),
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
  const _DailyLog({required this.meals});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: meals.map((m) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _MealCard(meal: m),
        )).toList(),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealSection meal;
  const _MealCard({required this.meal});

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
                _AddButton(),
              ],
            ),
            if (meal.entries.isNotEmpty) ...[
              const SizedBox(height: 8),
              Divider(color: cs.surfaceContainer, height: 1),
              const SizedBox(height: 8),
              ...meal.entries.asMap().entries.map((e) {
                final isLast = e.key == meal.entries.length - 1;
                return Column(children: [
                  _FoodEntryRow(entry: e.value),
                  if (!isLast) Divider(color: cs.surfaceContainerLowest, height: 1, thickness: 1),
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
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const CustomRecipeBuilderScreen(),
                  ));
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
  const _FoodEntryRow({required this.entry});

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
    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(entry.detail, style: Theme.of(context).textTheme.labelSmall),
                ],
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
          ],
        ),
      ),
    );
  }
}

class _WaterCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const WaterTrackingScreen())),
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
                          widthFactor: 2.5 / 3.0,
                          child: Container(height: 6, color: cs.secondary),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 4),
                    Text('2.5L of 3.0L',
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

class _BottomNavBar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  const _BottomNavBar({required this.selected, required this.onTap});

  static const _items = [
    (Icons.home_rounded,        Icons.home_outlined,          'Home'),
    (Icons.search_rounded,      Icons.search_outlined,        'Search'),
    (Icons.auto_awesome_rounded,Icons.auto_awesome_outlined,  'Planner'),
    (Icons.insights_rounded,    Icons.insights_outlined,      'Trends'),
    (Icons.person_rounded,      Icons.person_outline_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: const [BoxShadow(color: Color(0x141F2937), blurRadius: 12, offset: Offset(0, -4))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          final isActive = i == selected;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? cs.primaryContainer : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isActive ? item.$1 : item.$2, size: 24,
                      color: isActive ? cs.onPrimaryContainer : cs.onSurfaceVariant),
                  const SizedBox(height: 4),
                  Text(item.$3,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 11,
                          fontWeight: FontWeight.w500, letterSpacing: 0.5,
                          color: isActive ? cs.onPrimaryContainer : cs.onSurfaceVariant)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}