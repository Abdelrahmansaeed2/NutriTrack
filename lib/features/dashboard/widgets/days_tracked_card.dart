import 'package:flutter/material.dart';
import 'package:nutri_track/core/theme/app_theme.dart';

class DaysTrackedCard extends StatelessWidget {
  final int daysTracked;

  const DaysTrackedCard({
    super.key,
    required this.daysTracked,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(
                  Icons.date_range,
                  color: Colors.green,
                  size: 30,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Total Days Tracked',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.green,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                  '$daysTracked',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 48,
                      color: Colors.green),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    'Days')
              ],
            ),
            const LinearProgressIndicator(
              value: 1.0,
              backgroundColor: Colors.black38,
              color: AppTheme.primaryBrandColor,
              minHeight: 8,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            )
          ],
        ),
      ),
    );
  }
}
