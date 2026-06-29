import 'package:flutter/material.dart';
import 'package:nutri_track/core/theming/styles.dart';

class AlreadyHaveAccount extends StatelessWidget {
  const AlreadyHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // TODO: Navigate to login screen
      },
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF00B074),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
      child: Text(
        'I already have an account',
        style: AppTextStyles.font18green600,
      ),
    );
  }
}
