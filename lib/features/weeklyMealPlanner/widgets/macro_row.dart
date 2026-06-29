import 'package:flutter/material.dart';

class MacroRow extends StatelessWidget {
  final String label;
  final double value;
  final double target;
  final Color color;

  const MacroRow({
    required this.label,
    required this.value,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (value / target).clamp(0.0, 1.0);
    return Row(
      children: [
        SizedBox(
          width: 52,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${value.toInt()}g',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}