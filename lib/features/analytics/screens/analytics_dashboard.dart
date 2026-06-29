import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nutri_track/core/theme/app_theme.dart';
import 'package:nutri_track/features/analytics/widgets/analytics_header.dart';
import 'package:nutri_track/features/analytics/widgets/bottom_widget_cards.dart';
import 'package:nutri_track/features/analytics/widgets/intake_bar_chart.dart';
import 'package:nutri_track/features/analytics/widgets/my_line_chart.dart';
import 'package:nutri_track/features/analytics/widgets/stock_chart_card.dart';
import 'package:nutri_track/features/analytics/widgets/tracking_card.dart';

class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.only(left: 16),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/user.jpg'),
            ),
          ),
          title: const Text(
            'NutriTrack AI',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBrandColor,
                fontSize: 36),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.black87,
                    size: 28,
                  ),
                  Positioned(
                    right: 2,
                    top: 1,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AnalyticsHeader(),
                SizedBox(
                  height: 20,
                ),
                TrackingCard(
                    title: 'TOTAL WEIGHT LOST',
                    iconVal: Icons.trending_down,
                    iconColor: Colors.green,
                    gainedValue: 4.2,
                    correspondingValue: 'lbs',
                    bottomWidget: BottomWidgetCards(
                      iconVal: Icons.trending_down,
                      targetText: '-1.5% this month',
                    )),
                SizedBox(
                  height: 10,
                ),
                TrackingCard(
                    title: 'AVG DAILY DEFICIT',
                    iconVal: Icons.local_fire_department,
                    iconColor: Colors.red,
                    gainedValue: 350,
                    correspondingValue: 'kcal',
                    bottomWidget: BottomWidgetCards(
                      iconVal: Icons.playlist_add_check_circle_outlined,
                      targetText: 'On target',
                    )),
                SizedBox(
                  height: 10,
                ),
                TrackingCard(
                    title: 'PROTIEN GOAL HIT',
                    iconVal: Icons.fitness_center,
                    iconColor: Colors.orange,
                    gainedValue: 24,
                    correspondingValue: '/ 30 days',
                    bottomWidget: LinearProgressIndicator(
                      value: .75,
                      backgroundColor: Colors.black38,
                      color: Colors.red,
                      minHeight: 8,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    )),
                SizedBox(
                  height: 10,
                ),
                TrackingCard(
                    title: 'ACTIVE DAYS',
                    iconVal: Icons.directions_run,
                    iconColor: Colors.blue,
                    gainedValue: 18,
                    correspondingValue: 'days',
                    bottomWidget: BottomWidgetCards(
                      iconVal: Icons.trending_up,
                      targetText: '+2 from last month',
                    )),
                SizedBox(
                  height: 10,
                ),
                StockChartCard(
                  title: 'Weight Trend (30 Days)',
                  dataDescription: 'Export Data',
                  chart: MyLineChart(
                    stockPrices: [178, 177, 174, 172, 170, 168, 165],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                const StockChartCard(
                    title: 'Average Calorie Adherence',
                    dataDescription: 'Weekly Avg',
                    chart: IntakeBarChart(
                      data: [
                        {'week': 'Week 1', 'actual': 3000, 'target': 2150},
                        {'week': 'Week 2', 'actual': 2100, 'target': 2150},
                        {'week': 'Week 3', 'actual': 2250, 'target': 2150},
                        {'week': 'Week 4', 'actual': 2150, 'target': 2150},
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
