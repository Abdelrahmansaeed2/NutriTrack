import 'package:flutter/material.dart';
import 'package:nutri_track/core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: AppTheme.primaryBrandColor,
        letterSpacing: 1.2,
      ),
    );
  }
}
