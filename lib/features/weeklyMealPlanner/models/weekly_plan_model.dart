import 'day_plan_model.dart';

class WeeklyPlan {
  final String id;
  final String startDate;
  final Map<String, DayPlan> days; 

  const WeeklyPlan({
    required this.id,
    required this.startDate,
    required this.days,
  });

  factory WeeklyPlan.fromJson(Map<String, dynamic> json) => WeeklyPlan(
        id: json['id'],
        startDate: json['startDate'],
        days: (json['days'] as Map<String, dynamic>).map(
          (date, dayJson) => MapEntry(date, DayPlan.fromJson(dayJson)),
        ),
      );

  DayPlan? getDay(String date) => days[date];
}