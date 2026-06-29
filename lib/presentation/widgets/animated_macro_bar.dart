import 'package:flutter/material.dart';

class AnimatedMacroBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final Color color;
  final Color backgroundColor;
  final double height;

  const AnimatedMacroBar({
    super.key,
    required this.value,
    required this.color,
    required this.backgroundColor,
    this.height = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: value.clamp(0.0, 1.0)),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, animatedValue, _) {
            return LinearProgressIndicator(
              value: animatedValue,
              backgroundColor: backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            );
          },
        ),
      ),
    );
  }
}
