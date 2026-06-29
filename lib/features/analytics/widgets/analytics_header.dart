import 'package:flutter/material.dart';

class AnalyticsHeader extends StatelessWidget {
  const AnalyticsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress & Analytics',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 32, color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Theme.of(context).textTheme.bodyMedium?.color),
              'Your 30-day performance overview.')
        ]);
  }
}
