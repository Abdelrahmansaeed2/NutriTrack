import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_vectors.dart';
import '../cubits/activity_goal_cubit.dart';
import '../cubits/activity_goal_state.dart';
import '../widgets/page_transitions.dart';
import 'api_food_search_screen.dart'; // Next screen in flow

class ActivityGoalScreen extends StatelessWidget {
  const ActivityGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActivityGoalCubit(),
      child: const ActivityGoalView(),
    );
  }
}

class ActivityGoalView extends StatelessWidget {
  const ActivityGoalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Top Navigation Header
                      Container(
                        color: const Color(0xFFF8F9FF),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.string(
                                    AppVectors.icon_14,
                                    width: 16,
                                    height: 16,
                                    colorFilter: const ColorFilter.mode(Color(0xFF3C4A42), BlendMode.srcIn),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              "Step 2 of 3",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF006C49),
                              ),
                            ),
                            const SizedBox(width: 40), // Balance the row
                          ],
                        ),
                      ),
                      
                      // Main Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Section
                              const Text(
                                "Activity Level",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF121C2A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Select your typical daily activity level to accurately calculate your metabolic baseline.",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF3C4A42),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Activity Cards Grid
                              BlocBuilder<ActivityGoalCubit, ActivityGoalState>(
                                builder: (context, state) {
                                  return Column(
                                    children: [
                                      _buildActivityCard(
                                        context,
                                        title: "Sedentary",
                                        description: "Desk job, little to no formal exercise.",
                                        iconVector: AppVectors.icon_15,
                                        iconWidth: 22,
                                        iconHeight: 18,
                                        level: ActivityLevel.sedentary,
                                        isSelected: state.selectedActivityLevel == ActivityLevel.sedentary,
                                      ),
                                      const SizedBox(height: 16),
                                      _buildActivityCard(
                                        context,
                                        title: "Active",
                                        description: "Moderate exercise 3-5 days a week.",
                                        iconVector: AppVectors.icon_16,
                                        iconWidth: 13,
                                        iconHeight: 22,
                                        level: ActivityLevel.active,
                                        isSelected: state.selectedActivityLevel == ActivityLevel.active,
                                      ),
                                      const SizedBox(height: 16),
                                      _buildActivityCard(
                                        context,
                                        title: "Athlete",
                                        description: "Heavy training daily, highly active job.",
                                        iconVector: AppVectors.icon_17,
                                        iconWidth: 20,
                                        iconHeight: 20,
                                        level: ActivityLevel.athlete,
                                        isSelected: state.selectedActivityLevel == ActivityLevel.athlete,
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),

                      // Bottom Sheet (Calculated Results)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF000000).withValues(alpha: 0.12),
                              offset: const Offset(0, -8),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            // Drag Handle
                            Container(
                              width: 48,
                              height: 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFFBBCABF),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Headings
                            const Text(
                              "Your Daily Target",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF121C2A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "BASED ON SEDENTARY PROFILE",
                              style: TextStyle(
                                fontFamily: 'JetBrains Mono',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3C4A42),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Emerald Ring Visualization
                            SizedBox(
                              width: 170,
                              height: 170,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // SVG Ring Custom Painter
                                  SizedBox(
                                    width: 170,
                                    height: 170,
                                    child: CustomPaint(
                                      painter: EmeraldRingPainter(),
                                    ),
                                  ),
                                  // Central Data Bubble
                                  Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFFFF),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFFDEE9FC), width: 1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF000000).withValues(alpha: 0.05),
                                          offset: const Offset(0, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "2,450",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF121C2A),
                                          ),
                                        ),
                                        const Text(
                                          "KCAL/DAY",
                                          style: TextStyle(
                                            fontFamily: 'JetBrains Mono',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF3C4A42),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          "BMR: 1,850",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF6C7A71),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Action Button
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                              child: BlocBuilder<ActivityGoalCubit, ActivityGoalState>(
                                builder: (context, state) {
                                  return ElevatedButton(
                                    onPressed: state.isNextEnabled
                                        ? () {
                                            context.go('/home');
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF10B981),
                                      disabledBackgroundColor: const Color(0xFF10B981).withValues(alpha: 0.5),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      minimumSize: const Size.fromHeight(56),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ).copyWith(
                                      shadowColor: WidgetStateProperty.resolveWith((states) {
                                        if (states.contains(WidgetState.disabled)) return Colors.transparent;
                                        return const Color(0xFF10B981).withValues(alpha: 0.3);
                                      }),
                                      elevation: WidgetStateProperty.resolveWith((states) {
                                        if (states.contains(WidgetState.disabled)) return 0;
                                        return 14; // Matches blur radius concept roughly in standard elevation
                                      }),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Complete Setup",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        SvgPicture.string(
                                          AppVectors.icon_13, // Standard chevron
                                          width: 17,
                                          height: 17,
                                          colorFilter: const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context, {
    required String title,
    required String description,
    required String iconVector,
    required double iconWidth,
    required double iconHeight,
    required ActivityLevel level,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => context.read<ActivityGoalCubit>().selectActivityLevel(level),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF4FF) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF10B981) : const Color(0xFFD9E3F6),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? const Color(0xFF10B981).withValues(alpha: 0.15) 
                  : const Color(0xFF1F2937).withValues(alpha: 0.05),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE6EEFF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.string(
                  iconVector,
                  width: iconWidth,
                  height: iconHeight,
                  colorFilter: ColorFilter.mode(
                    isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF006C49),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3C4A42),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmeraldRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 12.0; // Estimate from design

    final Paint bgPaint = Paint()
      ..color = const Color(0xFFD9E3F6)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - strokeWidth) / 2;

    // Draw background track
    canvas.drawCircle(center, radius, bgPaint);

    // Draw active progress (75%)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start at top center (-90 degrees)
      (2 * pi) * 0.75, // Sweep 75%
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
