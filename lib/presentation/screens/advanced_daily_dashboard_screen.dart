import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_vectors.dart';
import '../cubits/dashboard_cubit.dart';
import '../cubits/dashboard_state.dart';
import '../widgets/page_transitions.dart';
import 'ai_weekly_calendar_screen.dart'; // Next screen in flow

class AdvancedDailyDashboardScreen extends StatelessWidget {
  const AdvancedDailyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(),
      child: const AdvancedDailyDashboardView(),
    );
  }
}

class AdvancedDailyDashboardView extends StatelessWidget {
  const AdvancedDailyDashboardView({super.key});

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
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF10B981), width: 2),
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
                        AppVectors.icon_25, // Calendar/Settings icon
                        width: 16,
                        height: 20,
                        colorFilter: const ColorFilter.mode(Color(0xFF3C4A42), BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Section - Date Selector
                    Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: BlocBuilder<DashboardCubit, DashboardState>(
                        builder: (context, state) {
                          // Build a sliding window of dates around the selected date
                          final baseDate = DateTime(2023, 6, 12); // Starting Monday
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: 6, // Mon to Sat
                            itemBuilder: (context, index) {
                              final date = baseDate.add(Duration(days: index));
                              final isSelected = date.day == state.selectedDate.day;
                              return _buildDateSelectorItem(
                                context,
                                date: date,
                                isSelected: isSelected,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    
                    // Section - Hero: Macro Dashboard
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(12),
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
                            // Calories Ring
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: CustomPaint(
                                      painter: CaloriesRingPainter(),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "1,850",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF121C2A),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        "/ 2400 kcal",
                                        style: TextStyle(
                                          fontFamily: 'JetBrains Mono',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF3C4A42),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Macro Bars
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildMacroBar("Protein", "120g / 150g", const Color(0xFFFFDAD7), const Color(0xFFB91A24), 0.8),
                                  const SizedBox(height: 16),
                                  _buildMacroBar("Carbs", "210g / 250g", const Color(0xFFD8E2FF), const Color(0xFF0058BE), 0.84),
                                  const SizedBox(height: 16),
                                  _buildMacroBar("Fats", "54g / 70g", const Color(0xFF6FFBBE), const Color(0xFF006C49), 0.77),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Section - Daily Log
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildDailyLogCard(
                            title: "Breakfast",
                            iconVector: AppVectors.icon_27,
                            addButtonVector: AppVectors.icon_28,
                            totalKcal: "350 kcal",
                            items: [
                              _DailyLogItem(
                                title: "Boiled Eggs and Barley Bread",
                                subtitle: "2 Eggs, 1 Slice",
                                kcal: "350 kcal",
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDailyLogCard(
                            title: "Lunch",
                            iconVector: AppVectors.icon_29,
                            addButtonVector: AppVectors.icon_30,
                            totalKcal: "650 kcal",
                            items: [
                              _DailyLogItem(
                                title: "Grilled Chicken Salad",
                                subtitle: "150g Chicken, Mixed Greens",
                                kcal: "420 kcal",
                              ),
                              _DailyLogItem(
                                title: "Quinoa Bowl",
                                subtitle: "1 Cup",
                                kcal: "230 kcal",
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDailyLogCard(
                            title: "Dinner",
                            iconVector: AppVectors.icon_31,
                            addButtonVector: AppVectors.icon_32,
                            totalKcal: "Recommend: ~600",
                            items: [],
                          ),
                          const SizedBox(height: 16),
                          _buildDailyLogCard(
                            title: "Snacks",
                            iconVector: AppVectors.icon_33,
                            addButtonVector: AppVectors.icon_34,
                            totalKcal: "0 kcal",
                            items: [],
                          ),
                          const SizedBox(height: 32),
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
    );
  }

  Widget _buildDateSelectorItem(
    BuildContext context, {
    required DateTime date,
    required bool isSelected,
  }) {
    final dayStr = DateFormat('E').format(date).toUpperCase();
    final dateStr = date.day.toString();

    return GestureDetector(
      onTap: () => context.read<DashboardCubit>().selectDate(date),
      child: Container(
        width: 56,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF006C49) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayStr,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF3C4A42),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateStr,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF3C4A42),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroBar(String title, String values, Color trackColor, Color progressColor, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF121C2A),
              ),
            ),
            Text(
              values,
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3C4A42),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: trackColor,
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
      ],
    );
  }

  Widget _buildDailyLogCard({
    required String title,
    required String iconVector,
    required String addButtonVector,
    required String totalKcal,
    required List<_DailyLogItem> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: items.isNotEmpty
                  ? const Border(bottom: BorderSide(color: Color(0xFFE6EEFF)))
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.string(
                      iconVector,
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(Color(0xFF006C49), BlendMode.srcIn),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF121C2A),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      totalKcal,
                      style: const TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3C4A42),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEFF4FF),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.string(
                          addButtonVector,
                          width: 10,
                          height: 10,
                          colorFilter: const ColorFilter.mode(Color(0xFF006C49), BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Items
          if (items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: index != items.length - 1
                          ? const Border(bottom: BorderSide(color: Color(0xFFFFFFFF))) // Figma shows #FFFFFF border between items implicitly by margin, but we use subtle or no divider
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF121C2A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle,
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6EEFF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.kcal,
                            style: const TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF121C2A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
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

class CaloriesRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 10.0; 

    final Paint bgPaint = Paint()
      ..color = const Color(0xFFDEE9FC)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = const Color(0xFF006C49)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - strokeWidth) / 2;

    canvas.drawCircle(center, radius, bgPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, 
      (2 * pi) * (1850 / 2400), 
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DailyLogItem {
  final String title;
  final String subtitle;
  final String kcal;

  _DailyLogItem({
    required this.title,
    required this.subtitle,
    required this.kcal,
  });
}
