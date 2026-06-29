
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/food_detail_models.dart';

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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final food = widget.food;

    
    final macroColors = [cs.primary, cs.secondary, cs.tertiary];

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
                  _TopBar(),
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
                    macros: food.macros,
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
            _AddToLogButton(),
          ],
        ),
      ),
    );
  }
}


class _TopBar extends StatelessWidget {
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
          const Row(
            children: [
              _IconBtn(icon: Icons.favorite_border),
               SizedBox(width: 4),
              _IconBtn(icon: Icons.more_vert),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  const _IconBtn({required this.icon});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(99),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, color: cs.onSurfaceVariant, size: 22),
        ),
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
            top: 16, left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLowest.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: cs.surfaceContainerHighest),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 8, height: 8,
                      decoration: BoxDecoration(color: cs.secondary, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text(category.toUpperCase(),
                      style: TextStyle(fontFamily: 'Inter', fontSize: 11,
                          fontWeight: FontWeight.w500, letterSpacing: 0.8,
                          color: cs.onSurface)),
                ],
              ),
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
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 4),
          Text(subtitle,
              style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: cs.onSurfaceVariant)),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.surfaceContainerHighest),
          boxShadow: [BoxShadow(color: const Color(0xFF1F2937).withValues(alpha: 0.05),
              blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Serving Size', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text('Grams (g)',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: cs.onSurfaceVariant)),
            ]),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: cs.outline),
              ),
              child: Row(children: [
                _StepBtn(icon: Icons.remove, onTap: onDecrement),
                SizedBox(
                  width: 56,
                  child: Text('$grams', textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 24,
                          fontWeight: FontWeight.w700, color: cs.primary)),
                ),
                _StepBtn(icon: Icons.add, onTap: onIncrement),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: SizedBox(width: 32, height: 32,
            child: Icon(icon, size: 20, color: cs.onSurfaceVariant)),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MacroPieChart(macros: macros, kcal: kcal, colors: macroColors),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: List.generate(macros.length, (i) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MacroRow(macro: macros[i], color: macroColors[i]),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroPieChart extends StatelessWidget {
  final List<MacroNutrient> macros;
  final int kcal;
  final List<Color> colors;
  const _MacroPieChart({required this.macros, required this.kcal, required this.colors});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 140, height: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.surfaceContainerHighest),
        boxShadow: [BoxShadow(color: const Color(0xFF1F2937).withValues(alpha: 0.05),
            blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(110, 110),
            painter: _PiePainter(macros: macros, colors: colors,
                trackColor: cs.surfaceContainerHigh),
          ),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Text('$kcal', style: TextStyle(fontFamily: 'Inter', fontSize: 24,
                fontWeight: FontWeight.w700, color: cs.onSurface)),
            Text('kcal', style: TextStyle(fontFamily: 'Inter', fontSize: 11,
                fontWeight: FontWeight.w500, letterSpacing: 0.5,
                color: cs.onSurfaceVariant)),
          ]),
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
        boxShadow: [BoxShadow(color: const Color(0xFF1F2937).withValues(alpha: 0.04),
            blurRadius: 8, offset: const Offset(0, 2))],
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
            boxShadow: [BoxShadow(color: const Color(0xFF1F2937).withValues(alpha: 0.05),
                blurRadius: 12, offset: const Offset(0, 4))],
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


class _AddToLogButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest.withValues(alpha: 0.95),
          border: Border(top: BorderSide(color: cs.surfaceContainerHighest)),
        ),
        child: ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('Add to Log'),
        ),
      ),
    );
  }
}
