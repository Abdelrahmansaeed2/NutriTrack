import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_vectors.dart';
import '../cubits/analytics_cubit.dart';
import '../cubits/analytics_state.dart';

class ProgressAnalyticsDashboardScreen extends StatelessWidget {
  const ProgressAnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnalyticsCubit(),
      child: const ProgressAnalyticsDashboardView(),
    );
  }
}

class ProgressAnalyticsDashboardView extends StatelessWidget {
  const ProgressAnalyticsDashboardView({super.key});

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
                        decoration: const BoxDecoration(
                          color: Color(0xFFD9E3F6),
                          shape: BoxShape.circle,
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
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Center(
                      child: SvgPicture.string(
                        AppVectors.icon_40, // Assuming this is settings/actions
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(Color(0xFF3C4A42), BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Section
                      const Text(
                        "Progress & Analytics",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF121C2A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Your 30-day performance overview.",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF3C4A42),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Bento Grid Stats Cards
                      BlocBuilder<AnalyticsCubit, AnalyticsState>(
                        builder: (context, state) {
                          if (state.status == AnalyticsStatus.loading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (state.status == AnalyticsStatus.error) {
                            return Center(
                              child: Text(
                                state.errorMessage ?? 'Failed to load analytics',
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          final summary = state.dashboard?.summary;
                          final weightChange = summary?.weightChange ?? 0.0;
                          final avgCal = summary?.averageCalories ?? 0.0;
                          final waterRate = summary?.waterComplianceRate ?? 0.0;
                          return GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.95,
                            children: [
                              _buildStatCard(
                                title: "TOTAL WEIGHT LOST",
                                value: weightChange.abs().toStringAsFixed(1),
                                unit: "kg",
                                primaryColor: const Color(0xFF10B981),
                                trendText: weightChange < 0 ? "Losing" : "Gaining",
                                trendColor: const Color(0xFF006C49),
                                topIconVector: AppVectors.icon_74,
                                trendIconVector: AppVectors.icon_75,
                              ),
                              _buildStatCard(
                                title: "AVG DAILY CALORIES",
                                value: avgCal.toInt().toString(),
                                unit: "kcal",
                                primaryColor: const Color(0xFF2170E4),
                                trendText: "This period",
                                trendColor: const Color(0xFF006C49),
                                topIconVector: AppVectors.icon_76,
                                trendIconVector: AppVectors.icon_77,
                              ),
                              _buildStatCard(
                                title: "WATER COMPLIANCE",
                                value: (waterRate * 100).toInt().toString(),
                                unit: "%",
                                primaryColor: const Color(0xFFFF7A73),
                                trendText: "",
                                trendColor: Colors.transparent,
                                topIconVector: AppVectors.icon_78,
                                trendIconVector: "",
                                isProgressBar: true,
                              ),
                              _buildStatCard(
                                title: "ACTIVE DAYS",
                                value: (state.dashboard?.weeklyAdherence.length ?? 0).toString(),
                                unit: "days",
                                primaryColor: const Color(0xFF6C7A71),
                                trendText: "Tracked",
                                trendColor: const Color(0xFF3C4A42),
                                topIconVector: AppVectors.icon_79,
                                trendIconVector: AppVectors.icon_80,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // Main Chart Section: Weight Trend
                      Container(
                        padding: const EdgeInsets.all(16),
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Weight Trend (30 Days)",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF121C2A),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.read<AnalyticsCubit>().exportData();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Exporting Data...'), backgroundColor: Color(0xFF10B981)),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF4FF),
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                    child: const Text(
                                      "Export Data",
                                      style: TextStyle(
                                        fontFamily: 'JetBrains Mono',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF006C49),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 180,
                              child: _buildWeightLineChart(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Secondary Chart: Calorie Adherence
                      Container(
                        padding: const EdgeInsets.all(16),
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Average Calorie Adherence",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF121C2A),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: const Text(
                                    "Weekly Avg",
                                    style: TextStyle(
                                      fontFamily: 'JetBrains Mono',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF00422B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 180,
                              child: _buildCalorieBarChart(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required Color primaryColor,
    required String trendText,
    required Color trendColor,
    required String topIconVector,
    required String trendIconVector,
    bool isProgressBar = false,
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
      child: Stack(
        children: [
          // Decorative bar at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 4,
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3C4A42),
                        ),
                      ),
                    ),
                    SvgPicture.string(
                      topIconVector,
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF121C2A),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3C4A42),
                      ),
                    ),
                  ],
                ),
                if (isProgressBar)
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9E3F6),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 24,
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 6,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    children: [
                      if (trendIconVector.isNotEmpty)
                        SvgPicture.string(
                          trendIconVector,
                          width: 12,
                          height: 12,
                          colorFilter: ColorFilter.mode(trendColor, BlendMode.srcIn),
                        ),
                      if (trendIconVector.isNotEmpty) const SizedBox(width: 4),
                      Text(
                        trendText,
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: trendColor,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Color(0xFFF3F4F6),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, color: Color(0xFF3C4A42));
                switch (value.toInt()) {
                  case 0: return const Text('Week 1', style: style);
                  case 1: return const Text('Week 2', style: style);
                  case 2: return const Text('Week 3', style: style);
                  case 3: return const Text('Week 4', style: style);
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 2,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString(), style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, color: Color(0xFF3C4A42)));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 3,
        minY: 170,
        maxY: 180,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 178),
              FlSpot(1, 176.5),
              FlSpot(2, 175),
              FlSpot(3, 173.8),
            ],
            isCurved: true,
            color: const Color(0xFF10B981),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 2500,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, color: Color(0xFF3C4A42));
                String text;
                switch (value.toInt()) {
                  case 0: text = 'M'; break;
                  case 1: text = 'T'; break;
                  case 2: text = 'W'; break;
                  case 3: text = 'T'; break;
                  case 4: text = 'F'; break;
                  case 5: text = 'S'; break;
                  case 6: text = 'S'; break;
                  default: text = ''; break;
                }
                return SideTitleWidget(meta: meta, child: Text(text, style: style));
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 500,
          getDrawingHorizontalLine: (value) {
            // Draw a dashed target line at 2000 kcal
            if (value == 2000) {
              return const FlLine(color: Color(0xFF2170E4), strokeWidth: 1, dashArray: [4, 4]);
            }
            return const FlLine(color: Color(0xFFF3F4F6), strokeWidth: 1);
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          _buildBarGroup(0, 1950, isTarget: true),
          _buildBarGroup(1, 2100, isTarget: false),
          _buildBarGroup(2, 2050, isTarget: false),
          _buildBarGroup(3, 1900, isTarget: true),
          _buildBarGroup(4, 2200, isTarget: false),
          _buildBarGroup(5, 2400, isTarget: false),
          _buildBarGroup(6, 1850, isTarget: true),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, {required bool isTarget}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isTarget ? const Color(0xFF10B981) : const Color(0xFFBBCABF),
          width: 16,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
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
