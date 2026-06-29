import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nutri_track/core/network/api_client.dart';
import '../models/water_tracking_models.dart';
import '../cubits/water_tracking_cubit.dart';
import '../cubits/water_tracking_state.dart';
import '../services/water_tracking_service.dart';

class WaterTrackingScreen extends StatefulWidget {
  final String? initialDateStr;
  const WaterTrackingScreen({super.key, this.initialDateStr});

  @override
  State<WaterTrackingScreen> createState() => _WaterTrackingScreenState();
}

class _WaterTrackingScreenState extends State<WaterTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  late final String _dateStr;

  final List<QuickAddOption> _quickOptions = const [
    QuickAddOption(label: '250ml', sublabel: 'Glass',  ml: 250, type: WaterEntryType.glass),
    QuickAddOption(label: '500ml', sublabel: 'Bottle', ml: 500, type: WaterEntryType.bottle),
    QuickAddOption(label: 'Custom', sublabel: '',      ml: 0,   type: WaterEntryType.custom),
  ];

  @override
  void initState() {
    super.initState();
    _dateStr = widget.initialDateStr ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
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

  void _addWater(BuildContext context, int ml) {
    if (ml == 0) {
      _showCustomDialog(context);
      return;
    }
    final typeStr = ml == 250 ? 'glass' : 'bottle';
    context.read<WaterTrackingCubit>().addWater(_dateStr, ml, typeStr);
  }

  void _showCustomDialog(BuildContext context) {
    final controller = TextEditingController();
    final cs = Theme.of(context).colorScheme;
    final cubit = context.read<WaterTrackingCubit>();
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
                cubit.addWater(_dateStr, ml, 'custom');
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
    return BlocProvider(
      create: (_) => WaterTrackingCubit(WaterTrackingService(ApiClient.instance.dio))
        ..loadWaterLog(_dateStr),
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: BlocBuilder<WaterTrackingCubit, WaterTrackingState>(
            builder: (context, state) {
              if (state is WaterTrackingLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is WaterTrackingError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<WaterTrackingCubit>().loadWaterLog(_dateStr),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is WaterTrackingLoaded) {
                WaterEntryType parseType(String typeStr) {
                  switch (typeStr.toLowerCase()) {
                    case 'glass': return WaterEntryType.glass;
                    case 'bottle': return WaterEntryType.bottle;
                    default: return WaterEntryType.custom;
                  }
                }

                String getLabel(int ml, WaterEntryType type) {
                  if (type == WaterEntryType.glass) return 'Glass of Water';
                  if (type == WaterEntryType.bottle) return 'Water Bottle';
                  return 'Custom Amount';
                }

                String formatTime(dynamic timestamp) {
                  if (timestamp == null) return '';
                  if (timestamp is String) {
                    try {
                      final dt = DateTime.parse(timestamp).toLocal();
                      return DateFormat('hh:mm a').format(dt);
                    } catch (_) {
                      return timestamp;
                    }
                  }
                  return '';
                }

                final waterState = WaterState(
                  currentLiters: state.totalMl / 1000,
                  goalLiters: state.goalMl / 1000,
                  log: state.logs.asMap().entries.map((e) {
                    final item = e.value as Map<String, dynamic>;
                    final ml = (item['amountMl'] as num?)?.toInt() ?? 250;
                    final typeStr = item['type'] as String? ?? 'glass';
                    final type = parseType(typeStr);
                    final label = getLabel(ml, type);
                    final time = formatTime(item['timestamp']);
                    return WaterLogEntry(label: label, ml: ml, time: time, type: type);
                  }).toList(),
                );

                return Stack(
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
                                _ProgressSection(state: waterState, waveController: _waveController),
                                const SizedBox(height: 24),
                                _QuickAddSection(
                                  options: _quickOptions,
                                  onAdd: (ml) => _addWater(context, ml),
                                ),
                                const SizedBox(height: 24),
                                _TodaysLog(
                                  entries: waterState.log,
                                  onDelete: (index) {
                                    context.read<WaterTrackingCubit>().removeWater(_dateStr, index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    _LogWaterFAB(onTap: () => _addWater(context, 250)),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
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
                child: Icon(Icons.arrow_back, color: cs.onSurfaceVariant),
              ),
            ),
          ),
          Expanded(
            child: Text('Water Tracking',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
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
    return Column(
      children: [
        SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Wave container
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: cs.secondary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.secondary.withValues(alpha: 0.1), width: 4),
                ),
                child: ClipOval(
                  child: AnimatedBuilder(
                    animation: waveController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _WavePainter(
                          progress: state.progress,
                          waveValue: waveController.value,
                          color: cs.secondary.withValues(alpha: 0.8),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Percentage text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${(state.progress * 100).round()}%',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: state.progress > 0.55 ? Colors.white : cs.secondary,
                        letterSpacing: -1,
                      )),
                  Text(
                    '${state.currentLiters.toStringAsFixed(2)} / ${state.goalLiters.toStringAsFixed(1)}L',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: state.progress > 0.65
                          ? Colors.white.withValues(alpha: 0.9)
                          : cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          state.motivationText,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  final double progress;
  final double waveValue;
  final Color color;
  const _WavePainter({required this.progress, required this.waveValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    
    final yOffset = size.height * (1.0 - progress);
    
    path.moveTo(0, size.height);
    path.lineTo(0, yOffset);
    
    for (double x = 0; x <= size.width; x++) {
      final angle = (x / size.width * 2 * math.pi) + (waveValue * 2 * math.pi);
      final y = yOffset + math.sin(angle) * 8.0; 
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter old) =>
      old.progress != progress || old.waveValue != waveValue;
}

class _QuickAddSection extends StatelessWidget {
  final List<QuickAddOption> options;
  final ValueChanged<int> onAdd;
  const _QuickAddSection({required this.options, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.map((opt) {
        final isCustom = opt.type == WaterEntryType.custom;
        return GestureDetector(
          onTap: () => onAdd(opt.ml),
          child: Container(
            width: 96,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.surfaceContainerHigh),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1F2937).withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  isCustom ? Icons.add_circle_outline : Icons.water_drop_outlined,
                  color: cs.secondary,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(opt.label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
                if (!isCustom) ...[
                  const SizedBox(height: 2),
                  Text(opt.sublabel, style: Theme.of(context).textTheme.labelSmall),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _TodaysLog extends StatelessWidget {
  final List<WaterLogEntry> entries;
  final ValueChanged<int> onDelete;
  const _TodaysLog({required this.entries, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text("TODAY'S LOG",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: cs.onSurfaceVariant,
              )),
        ),
        const SizedBox(height: 12),
        if (entries.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(Icons.water_drop_outlined, color: cs.onSurfaceVariant.withValues(alpha: 0.4), size: 32),
                const SizedBox(height: 12),
                Text('No water logged yet', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final e = entries[i];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1F2937).withValues(alpha: 0.02),
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
                        color: cs.secondary.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        e.type == WaterEntryType.bottle ? Icons.local_drink : Icons.local_cafe,
                        color: cs.secondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.label, style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 2),
                          Text(e.time, style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                    ),
                    Text('+${e.ml}ml',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: cs.secondary,
                        )),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                      onPressed: () => onDelete(i),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

class _LogWaterFAB extends StatelessWidget {
  final VoidCallback onTap;
  const _LogWaterFAB({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Positioned(
      bottom: 24,
      right: 16,
      child: FloatingActionButton.extended(
        onPressed: onTap,
        backgroundColor: cs.secondary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.water_drop),
        label: const Text('Log 250ml',
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}