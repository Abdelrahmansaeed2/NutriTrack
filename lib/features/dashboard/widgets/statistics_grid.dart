import 'package:flutter/material.dart';

class StatisticsGrid extends StatelessWidget {
  final double currentWeight;
  final double targetWeight;
  final int bmr;
  final int calorieTarget;

  const StatisticsGrid({
    super.key,
    required this.currentWeight,
    required this.targetWeight,
    required this.bmr,
    required this.calorieTarget,
  });

  Widget _buildStatBox(BuildContext context, {
    required String value,
    required String label,
    required IconData icon,
    required Color iconBgColor,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black26
                : Colors.black12,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconBgColor.withValues(alpha: 0.1),
            child: Icon(icon, color: iconBgColor),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyMedium?.color),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatBox(
                context,
                value: '${currentWeight.toStringAsFixed(1)} kg',
                label: 'Current Weight',
                icon: Icons.scale_outlined,
                iconBgColor: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatBox(
                context,
                value: '${targetWeight.toStringAsFixed(1)} kg',
                label: 'Target Weight',
                icon: Icons.track_changes,
                iconBgColor: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatBox(
                context,
                value: '$bmr kcal',
                label: 'BMR',
                icon: Icons.bolt_outlined,
                iconBgColor: Colors.red,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatBox(
                context,
                value: '$calorieTarget kcal',
                label: 'Daily Target',
                icon: Icons.local_fire_department_outlined,
                iconBgColor: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
