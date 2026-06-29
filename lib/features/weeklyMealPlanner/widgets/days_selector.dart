import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  final List<String> dates; 
  final String selectedDate;
  final ValueChanged<String> onDateSelected;

  const DaySelector({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  static const _dayNames = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  String _dayName(String date) {
    final d = DateTime.parse(date);
    return _dayNames[d.weekday - 1];
  }

  String _dayNumber(String date) {
    return DateTime.parse(date).day.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = date == selectedDate;
          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1DB574) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? const Color(0xFF1DB574) : Colors.grey[300]!,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _dayName(date),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _dayNumber(date),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}