import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_vectors.dart';
import '../cubits/ai_meal_plan_cubit.dart';
import '../cubits/ai_meal_plan_state.dart';

class AIMealPlanSetupScreen extends StatelessWidget {
  const AIMealPlanSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AIMealPlanCubit(),
      child: const AIMealPlanSetupView(),
    );
  }
}

class AIMealPlanSetupView extends StatelessWidget {
  const AIMealPlanSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
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
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD9E3F6),
                              shape: BoxShape.circle,
                            ),
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
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Center(
                          child: SvgPicture.string(
                            AppVectors.icon_40, // General App Icon
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(Color(0xFF006C49), BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Main Content Canvas
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header Section
                          const Text(
                            "Configure AI Agent",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF121C2A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Set your parameters to generate a highly optimized nutritional protocol.",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF3C4A42),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Dietary Framework Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: const Color(0xFFD9E3F6)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1F2937).withValues(alpha: 0.03),
                                  offset: const Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.string(
                                      AppVectors.icon_62, // Standard document/setup icon
                                      width: 20,
                                      height: 20,
                                      colorFilter: const ColorFilter.mode(Color(0xFF006C49), BlendMode.srcIn),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Dietary Framework",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF121C2A),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                BlocBuilder<AIMealPlanCubit, AIMealPlanState>(
                                  buildWhen: (p, c) => p.isVegetarian != c.isVegetarian,
                                  builder: (context, state) {
                                    return _buildDietaryToggle(
                                      title: "Vegetarian",
                                      description: "Excludes meat and poultry",
                                      isActive: state.isVegetarian,
                                      onTap: () => context.read<AIMealPlanCubit>().toggleVegetarian(),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                BlocBuilder<AIMealPlanCubit, AIMealPlanState>(
                                  buildWhen: (p, c) => p.isKeto != c.isKeto,
                                  builder: (context, state) {
                                    return _buildDietaryToggle(
                                      title: "Ketogenic",
                                      description: "High fat, ultra-low carb macro ratio",
                                      isActive: state.isKeto,
                                      onTap: () => context.read<AIMealPlanCubit>().toggleKeto(),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                BlocBuilder<AIMealPlanCubit, AIMealPlanState>(
                                  buildWhen: (p, c) => p.isHalal != c.isHalal,
                                  builder: (context, state) {
                                    return _buildDietaryToggle(
                                      title: "Halal",
                                      description: "Adheres to Islamic dietary laws",
                                      isActive: state.isHalal,
                                      onTap: () => context.read<AIMealPlanCubit>().toggleHalal(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Allergies & Exclusions Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: const Color(0xFFD9E3F6)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1F2937).withValues(alpha: 0.03),
                                  offset: const Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.string(
                                      AppVectors.icon_62,
                                      width: 20,
                                      height: 20,
                                      colorFilter: const ColorFilter.mode(Color(0xFF006C49), BlendMode.srcIn),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Allergies & Exclusions",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF121C2A),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD9E3F6),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        "AI Parser Active",
                                        style: TextStyle(
                                          fontFamily: 'JetBrains Mono',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF3C4A42),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF4FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextField(
                                    maxLines: 3,
                                    onChanged: (text) => context.read<AIMealPlanCubit>().updateAllergies(text),
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF121C2A),
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "e.g., Peanuts, shellfish, lactose, cilantro...",
                                      hintStyle: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFBBCABF),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Daily Meal Cadence Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: const Color(0xFFD9E3F6)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1F2937).withValues(alpha: 0.03),
                                  offset: const Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: BlocBuilder<AIMealPlanCubit, AIMealPlanState>(
                              buildWhen: (p, c) => p.dailyMeals != c.dailyMeals,
                              builder: (context, state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.string(
                                          AppVectors.icon_62,
                                          width: 20,
                                          height: 20,
                                          colorFilter: const ColorFilter.mode(Color(0xFF006C49), BlendMode.srcIn),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "Daily Meal Cadence",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF121C2A),
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF10B981),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              state.dailyMeals.toString(),
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF006C49),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    SliderTheme(
                                      data: SliderThemeData(
                                        trackHeight: 8,
                                        activeTrackColor: const Color(0xFFDEE9FC),
                                        inactiveTrackColor: const Color(0xFFDEE9FC),
                                        thumbColor: const Color(0xFFFFFFFF),
                                        thumbShape: _CustomThumbShape(
                                          thumbRadius: 12,
                                          strokeWidth: 4,
                                          strokeColor: const Color(0xFF006C49),
                                        ),
                                        overlayColor: const Color(0xFF006C49).withValues(alpha: 0.1),
                                        tickMarkShape: SliderTickMarkShape.noTickMark,
                                      ),
                                      child: Slider(
                                        value: state.dailyMeals.toDouble(),
                                        min: 1,
                                        max: 6,
                                        divisions: 5,
                                        onChanged: (val) {
                                          context.read<AIMealPlanCubit>().updateDailyMeals(val);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("OMAD", style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: Color(0xFF6C7A71))),
                                          Text("Standard", style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: Color(0xFF6C7A71))),
                                          Text("Grazing", style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: Color(0xFF6C7A71))),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 120), // Spacing for FAB
                        ],
                      ),
                    ),
                  ),
                ),
                
                
              ],
            ),
            
            // Generate Smart Plan FAB
            Positioned(
              bottom: 100, // Above NavBar
              left: 16,
              right: 16,
              child: BlocBuilder<AIMealPlanCubit, AIMealPlanState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: state.isLoading ? null : () {
                      context.go('/planner');
                      context.read<AIMealPlanCubit>().generatePlan();
                    },
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF006C49),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withValues(alpha: 0.40),
                            offset: const Offset(0, 0),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                      child: Center(
                        child: state.isLoading 
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.string(
                                  AppVectors.icon_43, // AI/Wand Icon
                                  width: 20,
                                  height: 20,
                                  colorFilter: const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Generate Smart Plan",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFFFFFF),
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
          ],
        ),
      ),
    );
  }

  Widget _buildDietaryToggle({
    required String title,
    required String description,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
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
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3C4A42),
                    ),
                  ),
                ],
              ),
            ),
            // Custom Animated Toggle
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 50,
              height: 28,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                color: isActive ? const Color(0xFF006C49) : const Color(0xFFD9E3F6),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFFFFF),
                    border: Border.all(
                      color: isActive ? const Color(0xFFFFFFFF) : const Color(0xFFD1D5DB),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000).withValues(alpha: 0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
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

  Widget _buildNavItem(String title, String iconVector, double iconW, double iconH, bool isActive) {
    return Container(
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
            width: iconW,
            height: iconH,
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
    );
  }
}

// Custom Slider Thumb to match Figma properties: Fill #FFFFFF, Radius 8, Stroke #006C49, Shadow #000000 15% Offset 0,2 Blur 6
class _CustomThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final double strokeWidth;
  final Color strokeColor;

  const _CustomThumbShape({
    required this.thumbRadius,
    required this.strokeWidth,
    required this.strokeColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Draw Shadow
    final Path shadowPath = Path()..addOval(Rect.fromCircle(center: center, radius: thumbRadius));
    canvas.drawShadow(shadowPath, const Color(0xFF000000).withValues(alpha: 0.15), 6, true);
    
    // Slight offset for drop shadow simulation
    canvas.save();
    canvas.translate(0, 2);
    canvas.drawShadow(shadowPath, const Color(0xFF000000).withValues(alpha: 0.15), 6, false);
    canvas.restore();

    // Draw Fill
    final paintFill = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius, paintFill);

    // Draw Stroke
    final paintStroke = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, thumbRadius, paintStroke);
  }
}
