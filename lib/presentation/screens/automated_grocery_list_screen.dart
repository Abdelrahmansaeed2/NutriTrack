import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_vectors.dart';
import '../cubits/grocery_list_cubit.dart';
import '../cubits/grocery_list_state.dart';
import '../../features/tracking/models/grocery_list_model.dart';

class AutomatedGroceryListScreen extends StatelessWidget {
  const AutomatedGroceryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GroceryListCubit(),
      child: const AutomatedGroceryListView(),
    );
  }
}

class AutomatedGroceryListView extends StatelessWidget {
  const AutomatedGroceryListView({super.key});

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
                  decoration: BoxDecoration(
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
                            AppVectors.icon_40, // Settings/Actions icon assumed
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
                            "AUTOMATED PLANNER",
                            style: TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF006C49),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Grocery List for the Week",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF121C2A),
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Progress Summary
                          BlocBuilder<GroceryListCubit, GroceryListState>(
                            builder: (context, state) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFDEE9FC)),
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
                                    // SVG Progress Ring
                                    SizedBox(
                                      width: 42,
                                      height: 42,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CustomPaint(
                                            size: const Size(42, 42),
                                            painter: GroceryProgressPainter(
                                              progress: state.progressPercentage,
                                            ),
                                          ),
                                          Text(
                                            "${state.checkedItems}/${state.totalItems}",
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF006C49),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Progress",
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF121C2A),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "You have ${state.remainingItems} items left to buy.",
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF3C4A42),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => context.read<GroceryListCubit>().clearChecked(),
                                      child: const Text(
                                        "Clear Checked",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF006C49),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          
                          // Grocery List Grid (Bento style)
                          BlocBuilder<GroceryListCubit, GroceryListState>(
                            builder: (context, state) {
                              if (state.status == GroceryStatus.loading) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (state.status == GroceryStatus.error) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      children: [
                                        Text(
                                          state.errorMessage ?? 'Failed to load grocery list',
                                          style: const TextStyle(color: Colors.red),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () => context.read<GroceryListCubit>().loadLists(),
                                          child: const Text('Retry'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              final list = state.activeList;
                              if (list == null || list.items.isEmpty) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32),
                                    child: Text(
                                      'No items yet. Generate a meal plan to create your grocery list.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        color: Color(0xFF6C7A71),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Column(
                                children: list.items.map((item) => _buildListItem(context, item)).toList(),
                              );
                            },
                          ),
                          const SizedBox(height: 100), // FAB Padding
                        ],
                      ),
                    ),
                  ),
                ),
                
                
              ],
            ),
            
            // FAB for adding item
            Positioned(
              bottom: 100, // Above NavBar
              right: 16,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(16),
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
                  child: const Center(
                    child: Text(
                      "+", // Use + instead of "add" text for better FAB UI based on standard practices, even though trace says "add", the icon usually is a plus. If text is literal "add":
                      // "add" is often the ligature for Material Icons +. I'll just use a plus sign that matches the trace size.
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00422B),
                      ),
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

  // _buildCategoryCard removed — grocery list is now a flat list from API

  Widget _buildListItem(BuildContext context, GroceryListItem item) {
    return GestureDetector(
      onTap: () => context.read<GroceryListCubit>().toggleItem(item.name, item.isChecked),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Checkbox
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: item.isChecked ? const Color(0xFF10B981) : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: item.isChecked ? const Color(0xFF10B981) : const Color(0xFF6C7A71),
                ),
              ),
              child: item.isChecked
                  ? Center(
                      child: SvgPicture.string(
                        AppVectors.icon_85, // Check mark
                        width: 11.2,
                        height: 8.7,
                        colorFilter: const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            
            // Item Name
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: item.isChecked ? const Color(0xFF6B7280) : const Color(0xFF121C2A),
                  decoration: item.isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            
            // Quantity Badge
            Text(
              item.quantity,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: item.isChecked ? const Color(0xFFE5E7EB) : const Color(0xFFBBCABF), // fade if checked
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

class GroceryProgressPainter extends CustomPainter {
  final double progress;

  GroceryProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 4.0;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - strokeWidth) / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    // Track 
    final Paint trackPaint = Paint()
      ..color = const Color(0xFFDEE9FC)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress 
    final Paint progressPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
      
    const double startAngle = -pi / 2;
    final double sweepAngle = 2 * pi * progress;

    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant GroceryProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
