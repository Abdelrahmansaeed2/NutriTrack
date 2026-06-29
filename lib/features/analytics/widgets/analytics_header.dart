import 'package:flutter/material.dart';

class AnalyticsHeader extends StatelessWidget {
  const AnalyticsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress & Analytics',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 32, color: Colors.black),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black54),
              'Your 30-day performance overview.')
        ]);
  }
}
