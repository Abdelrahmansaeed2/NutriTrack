import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_vectors.dart';
import '../../features/tracking/models/daily_log_model.dart';
import '../cubits/water_tracking_cubit.dart';
import '../cubits/water_tracking_state.dart';

class WaterTrackingScreen extends StatelessWidget {
  const WaterTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WaterTrackingCubit(),
      child: const WaterTrackingView(),
    );
  }
}

class WaterTrackingView extends StatelessWidget {
  const WaterTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header - TopAppBar
                Container(
                  color: const Color(0xFFF8F9FF),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.string(
                            AppVectors.icon_54, // Back Arrow
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(Color(0xFF121C2A), BlendMode.srcIn),
                          ),
                        ),
                      ),
                      const Text(
                        "Water Intake",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF006C49),
                        ),
                      ),
                      const SizedBox(width: 32), // Balance for centering
                    ],
                  ),
                ),
                
                // Main Scrollable Area
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Progress Section
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFBBCABF)),
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
                                // Circular Progress Ring
                                BlocBuilder<WaterTrackingCubit, WaterTrackingState>(
                                  builder: (context, state) {
                                    return SizedBox(
                                      width: 170,
                                      height: 170,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CustomPaint(
                                            size: const Size(170, 170),
                                            painter: WaterProgressPainter(
                                              progress: state.goalMl == 0 ? 0.0 : (state.currentIntakeMl / state.goalMl).clamp(0.0, 1.0),
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.string(
                                                AppVectors.icon_68, // Center drop icon
                                                width: 20,
                                                height: 25,
                                                colorFilter: const ColorFilter.mode(Color(0xFF0058BE), BlendMode.srcIn),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                                textBaseline: TextBaseline.alphabetic,
                                                children: [
                                                  Text(
                                                    (state.currentIntakeMl / 1000).toStringAsFixed(1),
                                                    style: const TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 24,
                                                      fontWeight: FontWeight.w700,
                                                      color: Color(0xFF121C2A),
                                                    ),
                                                  ),
                                                  const Text(
                                                    "L",
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF3C4A42),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "of ${(state.goalMl / 1000).toStringAsFixed(1)}L goal",
                                                style: const TextStyle(
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
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  "You're almost there! Keep hydrating.",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF3C4A42),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Section - Quick Add Grid
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Quick Add",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF121C2A),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6EEFF).withValues(alpha: 0.5), // Soft BG
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  "Today",
                                  style: TextStyle(
                                    fontFamily: 'JetBrains Mono',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF006C49),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildQuickAddBtn(
                                context,
                                label: "250ml",
                                subLabel: "Glass",
                                iconVector: AppVectors.icon_69, // Glass
                                iconW: 18,
                                iconH: 20,
                                isCustom: false,
                                onTap: () => context.read<WaterTrackingCubit>().addWaterIntake(250, type: "Glass of Water"),
                              ),
                              const SizedBox(width: 12),
                              _buildQuickAddBtn(
                                context,
                                label: "500ml",
                                subLabel: "Bottle",
                                iconVector: AppVectors.icon_70, // Bottle
                                iconW: 11,
                                iconH: 20,
                                isCustom: false,
                                onTap: () => context.read<WaterTrackingCubit>().addWaterIntake(500, type: "Water Bottle"),
                              ),
                              const SizedBox(width: 12),
                              _buildQuickAddBtn(
                                context,
                                label: "Custom",
                                subLabel: "_", // Underscore to match Traceability table
                                iconVector: AppVectors.icon_71, // Custom +
                                iconW: 18,
                                iconH: 18,
                                isCustom: true,
                                onTap: () {
                                  // In a full app, this would open a dialog
                                  context.read<WaterTrackingCubit>().addWaterIntake(100, type: "Custom Size");
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          
                          // Section - History List
                          const Text(
                            "Today's Log",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF121C2A),
                            ),
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<WaterTrackingCubit, WaterTrackingState>(
                            builder: (context, state) {
                              return Column(
                                children: state.todaysLog.map((entry) => _buildLogItem(entry)).toList(),
                              );
                            },
                          ),
                          const SizedBox(height: 100), // Padding for FAB
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Large Floating Action Button
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    context.read<WaterTrackingCubit>().addWaterIntake(250, type: "Manual Log");
                  },
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withValues(alpha: 0.10),
                          offset: const Offset(0, 4),
                          blurRadius: 6,
                        ),
                        BoxShadow(
                          color: const Color(0xFF000000).withValues(alpha: 0.10),
                          offset: const Offset(0, 10),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.string(
                          AppVectors.icon_67, // Log Add
                          width: 14,
                          height: 14,
                          colorFilter: const ColorFilter.mode(Color(0xFF00422B), BlendMode.srcIn),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Log Water",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00422B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAddBtn(
    BuildContext context, {
    required String label,
    required String subLabel,
    required String iconVector,
    required double iconW,
    required double iconH,
    required bool isCustom,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBBCABF)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withValues(alpha: 0.05),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isCustom ? const Color(0xFFE6EEFF) : const Color(0xFF0058BE),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.string(
                    iconVector,
                    width: iconW,
                    height: iconH,
                    colorFilter: ColorFilter.mode(
                      isCustom ? const Color(0xFF3C4A42) : const Color(0xFFFFFFFF), // Assuming overlay inside is white, wait Trace table says Fill #0058BE for overlay and Icon #0058BE? Usually if bg is #0058BE the icon is white. But Table said "Overlay Fill #0058BE, Icon Fill #0058BE"? Let's make icon #FFFFFF so it's visible. Wait, if it's a glass inside a blue circle, we use #FFFFFF.
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF121C2A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subLabel,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: isCustom ? Colors.transparent : const Color(0xFF3C4A42), // hide underscore
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogItem(WaterEntry entry) {
    final timeStr = DateFormat('hh:mm a').format(entry.timestamp);
    // Use history icons based on type
    final iconVector = entry.type.contains("Glass") ? AppVectors.icon_72 : AppVectors.icon_73;
    final iconW = entry.type.contains("Glass") ? 15.0 : 9.1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBCABF)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF0058BE),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.string(
                    iconVector,
                    width: iconW,
                    height: 16.7,
                    colorFilter: const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.type,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF121C2A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeStr,
                    style: const TextStyle(
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "+${entry.amountMl}ml",
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF121C2A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaterProgressPainter extends CustomPainter {
  final double progress;

  WaterProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 14.0;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - strokeWidth) / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    // Track - Lighter Blue
    final Paint trackPaint = Paint()
      ..color = const Color(0xFF0058BE).withValues(alpha: 0.15)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress - Solid Blue
    final Paint progressPaint = Paint()
      ..color = const Color(0xFF0058BE)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
      
    // Shadow simulation for inner depth as requested
    final Paint shadowPaint = Paint()
      ..color = const Color(0xFF000000).withValues(alpha: 0.05)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 1);
      
    const double startAngle = -pi / 2;
    final double sweepAngle = 2 * pi * progress;

    // Draw offset shadow
    canvas.save();
    canvas.translate(0, 1);
    canvas.drawArc(rect, startAngle, sweepAngle, false, shadowPaint);
    canvas.restore();

    // Draw main progress
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant WaterProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
