import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IntakeBarChart extends StatelessWidget {
  const IntakeBarChart({
    super.key,
    required this.data,
  });

  final List<Map<String, Object>> data;

  @override
  Widget build(BuildContext context) {
    final weeks = data
        .map((entry) => entry['week'] as String? ?? '')
        .toList(growable: false);

    final maxValue = data.map((entry) {
      final actual = (entry['actual'] as num?)?.toDouble() ?? 0;
      final target = (entry['target'] as num?)?.toDouble() ?? 0;
      return max(actual, target);
    }).fold<double>(0, max);

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxValue.toDouble() + 300,
          barGroups: data.asMap().entries.map((entry) {
            final index = entry.key;
            final values = entry.value;
            final actual = (values['actual'] as num?)?.toDouble() ?? 0;
            final target = (values['target'] as num?)?.toDouble() ?? 0;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: actual,
                  color: Colors.green,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: target,
                  color: Colors.lightBlue.shade100,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(growable: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  final label = index < weeks.length ? weeks[index] : '';
                  return Text(
                    label,
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 11),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: Colors.grey, width: 1),
              bottom: BorderSide(color: Colors.grey, width: 1),
              right: BorderSide.none,
              top: BorderSide.none,
            ),
          ),
          gridData: const FlGridData(
            show: true,
            horizontalInterval: 100,
            drawVerticalLine: false,
          ),
        ),
      ),
    );
  }
}
