import 'package:flutter/material.dart';

class StockChartCard extends StatelessWidget {
  const StockChartCard(
      {super.key,
      required this.title,
      required this.dataDescription,
      required this.chart});

  final String title;
  final String dataDescription;
  final Widget chart;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    dataDescription,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),

            // Line Chart
            SizedBox(
              height: 200,
              child: chart,
            ),
          ],
        ),
      ),
    );
  }
}
