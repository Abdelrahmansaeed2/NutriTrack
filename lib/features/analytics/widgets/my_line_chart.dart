import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyLineChart extends StatelessWidget {
  const MyLineChart({
    super.key,
    required this.stockPrices,
  });

  final List<double> stockPrices;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
        borderData: FlBorderData(
            show: true,
            border: const Border(
              left:
                  BorderSide(color: Colors.grey, width: 1), // Show left border
              bottom: BorderSide(
                  color: Colors.grey, width: 1), // Show bottom border
              right: BorderSide.none, // 👈 Remove right border
              top: BorderSide.none,
            )),
        lineBarsData: [
          LineChartBarData(
            spots: stockPrices.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value);
            }).toList(),
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withValues(alpha: .2),
            ),
          ),
        ],
      ),
    );
  }
}
