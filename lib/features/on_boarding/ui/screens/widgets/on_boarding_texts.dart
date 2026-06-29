import 'package:flutter/material.dart';
import 'package:nutri_track/core/theming/colors.dart';
import 'package:nutri_track/core/theming/styles.dart';

class OnBoardingTexts extends StatelessWidget {
  const OnBoardingTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            style: AppTextStyles.font48Black700,
            children: [
              TextSpan(text: 'NutriTrack '),
              TextSpan(
                text: 'AI',
                style: TextStyle(color: AppColors.primaryGreen), // Brand Green
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Tagline
        Text(
          'Precision nutrition, engineered for\npeak performance.',
          textAlign: TextAlign.center,
          style: AppTextStyles.font16green400,
        ),
      ],
    );
  }
}
