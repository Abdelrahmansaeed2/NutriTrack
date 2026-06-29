import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_track/core/network/api_client.dart';
import 'package:nutri_track/core/widgets/Header.dart';
import 'package:nutri_track/features/analytics/widgets/analytics_header.dart';
import 'package:nutri_track/features/analytics/widgets/bottom_widget_cards.dart';
import 'package:nutri_track/features/analytics/widgets/intake_bar_chart.dart';
import 'package:nutri_track/features/analytics/widgets/my_line_chart.dart';
import 'package:nutri_track/features/analytics/widgets/stock_chart_card.dart';
import 'package:nutri_track/features/analytics/widgets/tracking_card.dart';
import '../cubits/analytics_cubit.dart';
import '../cubits/analytics_state.dart';
import '../services/analytics_service.dart';

class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnalyticsCubit(AnalyticsService(ApiClient.instance.dio))..loadAnalytics(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Header(),
              Expanded(
                child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
                  builder: (context, state) {
                    if (state is AnalyticsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is AnalyticsError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.read<AnalyticsCubit>().loadAnalytics(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is AnalyticsLoaded) {
                      final stats = state.stats;
                      final activeDays = stats['activeDays'] as int? ?? 0;
                      final proteinGoalHit = stats['proteinGoalHit'] as int? ?? 0;
                      final avgDailyDeficit = stats['avgDailyDeficit'] as int? ?? 0;
                      final totalWeightLost = (stats['totalWeightLost'] as num?)?.toDouble() ?? 0.0;
                      final weightTrendList = stats['weightTrend'] as List<dynamic>? ?? [];

                      List<double> weightPrices = weightTrendList.map((w) {
                        return (w['weightKg'] as num?)?.toDouble() ?? 0.0;
                      }).toList();

                      if (weightPrices.isEmpty) {
                        weightPrices = [75.0, 74.8, 74.5, 74.2, 74.0];
                      }

                      final double proteinProgress = activeDays > 0 ? (proteinGoalHit / activeDays).clamp(0.0, 1.0) : 0.0;

                      return RefreshIndicator(
                        onRefresh: () => context.read<AnalyticsCubit>().loadAnalytics(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AnalyticsHeader(),
                                const SizedBox(
                                  height: 20,
                                ),
                                TrackingCard(
                                    title: 'TOTAL WEIGHT LOST',
                                    iconVal: Icons.trending_down,
                                    iconColor: Colors.green,
                                    gainedValue: totalWeightLost,
                                    correspondingValue: 'kg',
                                    bottomWidget: BottomWidgetCards(
                                      iconVal: Icons.trending_down,
                                      targetText: '${(totalWeightLost * 2.2).toStringAsFixed(1)} lbs',
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                TrackingCard(
                                    title: 'AVG DAILY DEFICIT',
                                    iconVal: Icons.local_fire_department,
                                    iconColor: Colors.red,
                                    gainedValue: avgDailyDeficit.toDouble(),
                                    correspondingValue: 'kcal',
                                    bottomWidget: BottomWidgetCards(
                                      iconVal: Icons.playlist_add_check_circle_outlined,
                                      targetText: avgDailyDeficit > 0 ? 'On target' : 'Maintain weight',
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                TrackingCard(
                                    title: 'PROTEIN GOAL HIT',
                                    iconVal: Icons.fitness_center,
                                    iconColor: Colors.orange,
                                    gainedValue: proteinGoalHit.toDouble(),
                                    correspondingValue: '/ $activeDays days',
                                    bottomWidget: LinearProgressIndicator(
                                      value: proteinProgress,
                                      backgroundColor: Colors.black38,
                                      color: Colors.green,
                                      minHeight: 8,
                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                TrackingCard(
                                    title: 'ACTIVE DAYS',
                                    iconVal: Icons.directions_run,
                                    iconColor: Colors.blue,
                                    gainedValue: activeDays.toDouble(),
                                    correspondingValue: 'days',
                                    bottomWidget: const BottomWidgetCards(
                                      iconVal: Icons.trending_up,
                                      targetText: 'Keep it up!',
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                StockChartCard(
                                  title: 'Weight Trend (Logged)',
                                  dataDescription: 'Trend Line',
                                  chart: MyLineChart(
                                    stockPrices: weightPrices,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const StockChartCard(
                                    title: 'Average Calorie Adherence',
                                    dataDescription: 'Weekly Avg',
                                    chart: IntakeBarChart(
                                      data: [
                                        {'week': 'Week 1', 'actual': 2200, 'target': 2000},
                                        {'week': 'Week 2', 'actual': 2100, 'target': 2000},
                                        {'week': 'Week 3', 'actual': 1950, 'target': 2000},
                                        {'week': 'Week 4', 'actual': 2000, 'target': 2000},
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
