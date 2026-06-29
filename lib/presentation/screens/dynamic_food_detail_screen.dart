import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_vectors.dart';
import '../cubits/food_detail_cubit.dart';
import '../cubits/food_detail_state.dart';

class DynamicFoodDetailScreen extends StatelessWidget {
  const DynamicFoodDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FoodDetailCubit(),
      child: const DynamicFoodDetailView(),
    );
  }
}

class DynamicFoodDetailView extends StatelessWidget {
  const DynamicFoodDetailView({super.key});

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
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: SvgPicture.string(
                            AppVectors.icon_54, // Back Arrow
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(Color(0xFF3C4A42), BlendMode.srcIn),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Details",
                        style: TextStyle(
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
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Center(
                          child: SvgPicture.string(
                            AppVectors.icon_55, // Share/Bookmark
                            width: 20,
                            height: 18,
                            colorFilter: const ColorFilter.mode(Color(0xFF3C4A42), BlendMode.srcIn),
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Center(
                          child: SvgPicture.string(
                            AppVectors.icon_56, // Options vertical dots
                            width: 4,
                            height: 16,
                            colorFilter: const ColorFilter.mode(Color(0xFF3C4A42), BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hero Image Area
                    Container(
                      height: 240,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1F2937).withValues(alpha: 0.05),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Placeholder for actual image
                          Container(color: const Color(0xFFF3F4F6)),
                          // Floating Category Chip
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(9999),
                                border: Border.all(color: const Color(0xFFD9E3F6)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF0058BE),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    "HIGH PROTEIN",
                                    style: TextStyle(
                                      fontFamily: 'JetBrains Mono',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF121C2A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Title & Basic Info
                          const Text(
                            "Grilled Salmon",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF121C2A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Atlantic Salmon, wild caught",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF3C4A42),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Serving Adjuster Component
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFD9E3F6)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1F2937).withValues(alpha: 0.05),
                                  offset: const Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Serving Size",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF121C2A),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Grams (g)",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF3C4A42),
                                      ),
                                    ),
                                  ],
                                ),
                                // Interactive Stepper
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF4FF),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFBBCABF)),
                                  ),
                                  child: Row(
                                    children: [
                                      _buildStepperBtn(
                                        iconVector: AppVectors.icon_57, // Minus
                                        iconWidth: 12,
                                        iconHeight: 2,
                                        onTap: () => context.read<FoodDetailCubit>().decrementServing(),
                                      ),
                                      Container(
                                        width: 60,
                                        alignment: Alignment.center,
                                        child: BlocBuilder<FoodDetailCubit, FoodDetailState>(
                                          builder: (context, state) {
                                            return Text(
                                              state.servingGrams.toString(),
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF006C49),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      _buildStepperBtn(
                                        iconVector: AppVectors.icon_58, // Plus
                                        iconWidth: 12,
                                        iconHeight: 12,
                                        onTap: () => context.read<FoodDetailCubit>().incrementServing(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Bento Grid Macro Pie Chart Area
                          BlocBuilder<FoodDetailCubit, FoodDetailState>(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Main Chart Card
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          height: 180,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFFFFF),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: const Color(0xFFD9E3F6)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF1F2937).withValues(alpha: 0.05),
                                                offset: const Offset(0, 4),
                                                blurRadius: 12,
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SizedBox(
                                                width: 120,
                                                height: 120,
                                                child: CustomPaint(
                                                  painter: BentoPieChartPainter(),
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    state.currentKcal.toString(),
                                                    style: const TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 24,
                                                      fontWeight: FontWeight.w700,
                                                      color: Color(0xFF121C2A),
                                                    ),
                                                  ),
                                                  const Text(
                                                    "KCAL",
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
                                      ),
                                      const SizedBox(width: 16),
                                      // Detailed Breakdown List
                                      Expanded(
                                        flex: 4,
                                        child: SizedBox(
                                          height: 180,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              _buildBentoRow("Protein", "60%", "${state.currentProtein}g", const Color(0xFF006C49)),
                                              _buildBentoRow("Fat", "30%", "${state.currentFat}g", const Color(0xFF0058BE)),
                                              _buildBentoRow("Carbs", "10%", "${state.currentCarbs}g", const Color(0xFFB91A24)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // Micronutrients Expansion Panel
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFD9E3F6)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1F2937).withValues(alpha: 0.05),
                                  offset: const Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.string(
                                          AppVectors.icon_59,
                                          width: 18,
                                          height: 18,
                                          colorFilter: const ColorFilter.mode(Color(0xFF006C49), BlendMode.srcIn),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "Micronutrients",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF121C2A),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SvgPicture.string(
                                      AppVectors.icon_60, // Chevron
                                      width: 12,
                                      height: 7,
                                      colorFilter: const ColorFilter.mode(Color(0xFF3C4A42), BlendMode.srcIn),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _buildMicronutrientTag("Vit D"),
                                    _buildMicronutrientTag("Omega-3"),
                                    _buildMicronutrientTag("B12"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Pinned FAB Area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                border: Border(top: BorderSide(color: Color(0xFFD9E3F6))),
              ),
              child: GestureDetector(
                onTap: () {
                  // Add to log action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to log!'), backgroundColor: Color(0xFF10B981)),
                  );
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000).withValues(alpha: 0.05),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.string(
                        AppVectors.icon_53, // Add icon
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(Color(0xFF00422B), BlendMode.srcIn),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Add to Log",
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
          ],
        ),
      ),
    );
  }

  Widget _buildStepperBtn({
    required String iconVector,
    required double iconWidth,
    required double iconHeight,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.05),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.string(
            iconVector,
            width: iconWidth,
            height: iconHeight,
            colorFilter: const ColorFilter.mode(Color(0xFF3C4A42), BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Widget _buildBentoRow(String title, String percent, String amount, Color dotColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD9E3F6)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1F2937).withValues(alpha: 0.05),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF121C2A),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  percent,
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: dotColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  amount,
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
      ),
    );
  }

  Widget _buildMicronutrientTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD9E3F6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'JetBrains Mono',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF3C4A42),
        ),
      ),
    );
  }
}

class BentoPieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 14.0; 

    final Paint bgPaint = Paint()
      ..color = const Color(0xFFDEE9FC)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - strokeWidth) / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    // Draw full background ring
    canvas.drawCircle(center, radius, bgPaint);

    // Protein (60%) - #006C49
    final Paint proteinPaint = Paint()
      ..color = const Color(0xFF006C49)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, -pi / 2, (2 * pi) * 0.60, false, proteinPaint);

    // Fat (30%) - #0058BE
    final Paint fatPaint = Paint()
      ..color = const Color(0xFF0058BE)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, (-pi / 2) + ((2 * pi) * 0.60), (2 * pi) * 0.30, false, fatPaint);

    // Carbs (10%) - #B91A24
    final Paint carbsPaint = Paint()
      ..color = const Color(0xFFB91A24)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, (-pi / 2) + ((2 * pi) * 0.90), (2 * pi) * 0.10, false, carbsPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
