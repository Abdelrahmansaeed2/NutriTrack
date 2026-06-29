import 'package:flutter/material.dart';
import 'package:nutri_track/core/theme/app_theme.dart';

class DaysTrackedCard extends StatelessWidget {
  const DaysTrackedCard({super.key});
  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
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
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                  '842',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 48,
                      color: Colors.green),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    'Days')
              ],
            ),
            LinearProgressIndicator(
              value: .75,
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
