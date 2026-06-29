import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nutri_track/core/network/api_client.dart';
import '../models/food_detail_models.dart';
import '../cubits/food_detail_cubit.dart';
import '../cubits/food_detail_state.dart';
import '../services/food_detail_service.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodDetail food;
  const FoodDetailScreen({super.key, required this.food});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  late int _servingGrams;
  bool _microExpanded = false;

  @override
  void initState() {
    super.initState();
    _servingGrams = widget.food.servingGrams;
  }

  int get _adjustedKcal =>
      (widget.food.totalKcal * _servingGrams / widget.food.servingGrams).round();

  double _getAdjustedMacro(int index) {
    if (index >= widget.food.macros.length) return 0.0;
    return widget.food.macros[index].grams * _servingGrams / widget.food.servingGrams;
  }

  void _showMealTypeSelector(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cubit = context.read<FoodDetailCubit>();

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
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Select Meal Slot', style: Theme.of(context).textTheme.titleMedium),
              ),
              ...['Breakfast', 'Lunch', 'Dinner', 'Snacks'].map((meal) => ListTile(
                title: Text(meal, style: const TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  cubit.logMeal(
                    date: todayStr,
                    mealType: meal.toLowerCase(),
                    foodId: widget.food.id ?? 'custom_food',
                    name: widget.food.name,
                    quantity: _servingGrams.toDouble(),
                    calories: _adjustedKcal.toDouble(),
                    protein: _getAdjustedMacro(0),
                    carbs: _getAdjustedMacro(1),
                    fat: _getAdjustedMacro(2),
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final food = widget.food;
    final macroColors = [cs.primary, cs.secondary, cs.tertiary];

    return BlocProvider(
      create: (_) => FoodDetailCubit(FoodDetailService(ApiClient.instance.dio)),
      child: BlocConsumer<FoodDetailCubit, FoodDetailState>(
        listener: (context, state) {
          if (state is FoodDetailSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
          } else if (state is FoodDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is FoodDetailSubmitting;

          return Scaffold(
            backgroundColor: cs.surface,
            body: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 96),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TopBar(
                          foodId: food.id,
                          onFavoriteToggle: (fav) {
                            if (food.id != null) {
                              context.read<FoodDetailCubit>().toggleFavorite(food.id!, fav);
                            }
                          },
                        ),
                        _HeroImage(imageUrl: food.imageUrl, category: food.category),
                        const SizedBox(height: 16),
                        _TitleSection(name: food.name, subtitle: food.subtitle),
                        const SizedBox(height: 16),
                        _ServingAdjuster(
                          grams: _servingGrams,
                          onDecrement: () => setState(
                              () => _servingGrams = (_servingGrams - 10).clamp(10, 9999)),
                          onIncrement: () => setState(() => _servingGrams += 10),
                        ),
                        const SizedBox(height: 16),
                        _MacroSection(
                          macros: food.macros.asMap().entries.map((entry) {
                            final i = entry.key;
                            final m = entry.value;
                            return MacroNutrient(
                              label: m.label,
                              grams: _getAdjustedMacro(i),
                              percentage: m.percentage,
                            );
                          }).toList(),
                          kcal: _adjustedKcal,
                          macroColors: macroColors,
                        ),
                        const SizedBox(height: 16),
                        _MicronutrientsPanel(
                          tags: food.micronutrients,
                          expanded: _microExpanded,
                          onTap: () => setState(() => _microExpanded = !_microExpanded),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerLowest.withValues(alpha: 0.95),
                        border: Border(top: BorderSide(color: cs.surfaceContainerHighest)),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : () => _showMealTypeSelector(context),
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.add_circle_outline),
                        label: Text(isLoading ? 'Logging...' : 'Add to Log'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TopBar extends StatefulWidget {
  final String? foodId;
  final ValueChanged<bool> onFavoriteToggle;
  const _TopBar({required this.foodId, required this.onFavoriteToggle});

  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: cs.onSurfaceVariant),
                const SizedBox(width: 8),
                Text('Details', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() => _isFavorite = !_isFavorite);
                  widget.onFavoriteToggle(_isFavorite);
                },
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? cs.primary : cs.onSurfaceVariant,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.more_vert, color: cs.onSurfaceVariant, size: 22),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String imageUrl;
  final String category;
  const _HeroImage({required this.imageUrl, required this.category});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 240, width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(imageUrl, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: cs.surfaceContainerHigh,
                child: Icon(Icons.image_outlined, size: 48, color: cs.onSurfaceVariant),
              )),
          Positioned(
            left: 16, bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(category,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: cs.onPrimaryContainer)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  final String name;
  final String subtitle;
  const _TitleSection({required this.name, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}

class _ServingAdjuster extends StatelessWidget {
  final int grams;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  const _ServingAdjuster({required this.grams, required this.onDecrement, required this.onIncrement});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.surfaceContainerHighest),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Serving Size', style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: [
                _RoundButton(icon: Icons.remove, onTap: onDecrement),
                const SizedBox(width: 16),
                Text('$grams g',
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(width: 16),
                _RoundButton(icon: Icons.add, onTap: onIncrement),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: cs.onSurface),
      ),
    );
  }
}

class _MacroSection extends StatelessWidget {
  final List<MacroNutrient> macros;
  final int kcal;
  final List<Color> macroColors;
  const _MacroSection({required this.macros, required this.kcal, required this.macroColors});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.surfaceContainerHighest),
        ),
        child: Row(
          children: [
            _PieChart(macros: macros, colors: macroColors, kcal: kcal),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: List.generate(macros.length, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _MacroRow(macro: macros[i], color: macroColors[i]),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PieChart extends StatelessWidget {
  final List<MacroNutrient> macros;
  final List<Color> colors;
  final int kcal;
  const _PieChart({required this.macros, required this.colors, required this.kcal});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 120, height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(120, 120),
            painter: _PiePainter(
              macros: macros,
              colors: colors,
              trackColor: cs.surfaceContainerHigh,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$kcal',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 20,
                      fontWeight: FontWeight.w700, color: cs.onSurface)),
              Text('kcal',
                  style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _PiePainter extends CustomPainter {
  final List<MacroNutrient> macros;
  final List<Color> colors;
  final Color trackColor;
  const _PiePainter({required this.macros, required this.colors, required this.trackColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2 - 8;
    const strokeWidth = 10.0;
    canvas.drawCircle(Offset(cx, cy), radius,
        Paint()..color = trackColor..style = PaintingStyle.stroke..strokeWidth = strokeWidth);
    double startAngle = -math.pi / 2;
    for (int i = 0; i < macros.length; i++) {
      final sweep = 2 * math.pi * macros[i].percentage;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        startAngle, sweep, false,
        Paint()..color = colors[i]..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth..strokeCap = StrokeCap.round,
      );
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(_PiePainter old) => old.macros != macros;
}

class _MacroRow extends StatelessWidget {
  final MacroNutrient macro;
  final Color color;
  const _MacroRow({required this.macro, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.surfaceContainerHighest),
      ),
      child: Row(
        children: [
          Container(width: 10, height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(child: Text(macro.label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14))),
          Text('${(macro.percentage * 100).round()}%',
              style: TextStyle(fontFamily: 'Inter', fontSize: 11,
                  fontWeight: FontWeight.w500, color: color)),
          const SizedBox(width: 8),
          Text('${macro.grams.round()}g',
              style: TextStyle(fontFamily: 'Inter', fontSize: 11,
                  fontWeight: FontWeight.w500, color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _MicronutrientsPanel extends StatelessWidget {
  final List<MicronutrientTag> tags;
  final bool expanded;
  final VoidCallback onTap;
  const _MicronutrientsPanel({required this.tags, required this.expanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.surfaceContainerHighest),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.science_outlined, color: cs.primary, size: 22),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Micronutrients',
                      style: Theme.of(context).textTheme.titleMedium)),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.expand_more, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: tags.map((t) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(t.label, style: Theme.of(context).textTheme.labelSmall),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
