

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/water_tracking_models.dart';

class WaterTrackingScreen extends StatefulWidget {
  const WaterTrackingScreen({super.key});

  @override
  State<WaterTrackingScreen> createState() => _WaterTrackingScreenState();
}

class _WaterTrackingScreenState extends State<WaterTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  WaterState _state = const WaterState(
    currentLiters: 2.5,
    goalLiters: 3.0,
    log: [
      WaterLogEntry(label: 'Glass of Water', ml: 250, time: '02:30 PM', type: WaterEntryType.glass),
      WaterLogEntry(label: 'Water Bottle',   ml: 500, time: '11:15 AM', type: WaterEntryType.bottle),
      WaterLogEntry(label: 'Glass of Water', ml: 250, time: '08:00 AM', type: WaterEntryType.glass),
    ],
  );

  final List<QuickAddOption> _quickOptions = const [
    QuickAddOption(label: '250ml', sublabel: 'Glass',  ml: 250, type: WaterEntryType.glass),
    QuickAddOption(label: '500ml', sublabel: 'Bottle', ml: 500, type: WaterEntryType.bottle),
    QuickAddOption(label: 'Custom', sublabel: '',      ml: 0,   type: WaterEntryType.custom),
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _addWater(int ml) {
    if (ml == 0) {
      _showCustomDialog();
      return;
    }
    final now = TimeOfDay.now();
    final timeStr =
        '${now.hourOfPeriod.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.period.name.toUpperCase()}';
    setState(() {
      _state = _state.addEntry(WaterLogEntry(
        label: ml == 250 ? 'Glass of Water' : 'Water Bottle',
        ml: ml,
        time: timeStr,
        type: ml == 250 ? WaterEntryType.glass : WaterEntryType.bottle,
      ));
    });
  }

  void _showCustomDialog() {
    final controller = TextEditingController();
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cs.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Custom Amount', style: Theme.of(context).textTheme.titleMedium),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter ml (e.g. 350)',
            suffixText: 'ml',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.secondary, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final ml = int.tryParse(controller.text);
              if (ml != null && ml > 0) {
                Navigator.pop(context);
                _addWater(ml);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _TopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _ProgressSection(state: _state, waveController: _waveController),
                        const SizedBox(height: 24),
                        _QuickAddSection(options: _quickOptions, onAdd: _addWater),
                        const SizedBox(height: 24),
                        _TodaysLog(entries: _state.log),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _LogWaterFAB(onTap: () => _addWater(250)),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(99),
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.arrow_back, color: cs.onSurface),
              ),
            ),
          ),
          Expanded(
            child: Text('Water Intake',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: cs.primary)),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final WaterState state;
  final AnimationController waveController;
  const _ProgressSection({required this.state, required this.waveController});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F2937).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 192,
            height: 192,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(192, 192),
                  painter: _WaterRingPainter(
                    progress: state.progress,
                    ringColor: cs.secondary,
                    trackColor: cs.secondary.withValues(alpha: 0.1),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: waveController,
                      builder: (_, __) => Transform.translate(
                        offset: Offset(0, -5 * waveController.value),
                        child: Icon(Icons.water_drop, color: cs.secondary, size: 32),
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: state.currentLiters.toStringAsFixed(1),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),
                          TextSpan(
                            text: 'L',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'of ${state.goalLiters.toStringAsFixed(1)}L goal',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            state.motivationText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterRingPainter extends CustomPainter {
  final double progress;
  final Color ringColor;
  final Color trackColor;
  const _WaterRingPainter(
      {required this.progress, required this.ringColor, required this.trackColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2 - 14;
    const strokeWidth = 12.0;

    canvas.drawCircle(
      Offset(cx, cy),
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = ringColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_WaterRingPainter old) => old.progress != progress;
}


class _QuickAddSection extends StatelessWidget {
  final List<QuickAddOption> options;
  final ValueChanged<int> onAdd;
  const _QuickAddSection({required this.options, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quick Add', style: Theme.of(context).textTheme.titleMedium),
            Text('Today',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: cs.primary,
                )),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: options.map((opt) {
            final isCustom = opt.type == WaterEntryType.custom;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: opt == options.last ? 0 : 12),
                child: GestureDetector(
                  onTap: () => onAdd(opt.ml),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isCustom
                            ? cs.outlineVariant.withValues(alpha: 0.5)
                            : cs.outlineVariant.withValues(alpha: 0.3),
                        width: isCustom ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1F2937).withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isCustom
                                ? cs.surfaceContainer
                                : cs.secondary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCustom
                                ? Icons.edit_outlined
                                : opt.type == WaterEntryType.glass
                                    ? Icons.local_drink
                                    : Icons.water_drop_outlined,  
                            color: isCustom ? cs.onSurfaceVariant : cs.secondary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(opt.label,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              color: cs.onSurface,
                            )),
                        Text(opt.sublabel,
                            style: TextStyle(
                              fontSize: 10,
                              color: cs.onSurfaceVariant,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _TodaysLog extends StatelessWidget {
  final List<WaterLogEntry> entries;
  const _TodaysLog({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's Log", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ...entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _LogItem(entry: e),
            )),
      ],
    );
  }
}

class _LogItem extends StatelessWidget {
  final WaterLogEntry entry;
  const _LogItem({required this.entry});

  IconData get _icon {
    switch (entry.type) {
      case WaterEntryType.bottle: return Icons.water_drop_outlined;
      case WaterEntryType.custom: return Icons.edit_outlined;
      default: return Icons.local_drink;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F2937).withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, color: cs.secondary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.label,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500)),
                Text(entry.time,
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('+${entry.ml}ml',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                )),
          ),
        ],
      ),
    );
  }
}

class _LogWaterFAB extends StatelessWidget {
  final VoidCallback onTap;
  const _LogWaterFAB({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add),
        label: const Text('Log Water'),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          shadowColor: const Color(0xFF10B981).withValues(alpha: 0.3),
          elevation: 8,
        ),
      ),
    );
  }
}