import 'package:flutter/material.dart';
import 'package:nutri_track/core/theme/app_theme.dart';

class BottomWidgetCards extends StatelessWidget {
  const BottomWidgetCards(
      {super.key, required this.iconVal, required this.targetText});
  final IconData iconVal;
  final String targetText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconVal,
          color: AppTheme.primaryBrandColor,
          size: 14,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          targetText,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: Colors.green,
          ),
        )
      ],
    );
  }
}
