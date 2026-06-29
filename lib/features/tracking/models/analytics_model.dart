class AnalyticsDashboard {
  final AnalyticsSummary summary;
  final List<WeeklyAdherencePoint> weeklyAdherence;
  final List<WeightPoint> weightTrend;

  const AnalyticsDashboard({
    required this.summary,
    required this.weeklyAdherence,
    required this.weightTrend,
  });

  factory AnalyticsDashboard.fromJson(Map<String, dynamic> json) {
    return AnalyticsDashboard(
      summary: AnalyticsSummary.fromJson(
          json['summary'] as Map<String, dynamic>? ?? {}),
      weeklyAdherence: (json['weeklyAdherence'] as List<dynamic>?)
              ?.map((e) =>
                  WeeklyAdherencePoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      weightTrend: (json['weightTrend'] as List<dynamic>?)
              ?.map((e) =>
                  WeightPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AnalyticsSummary {
  final double currentWeight;
  final double weightChange;
  final double averageCalories;
  final double waterComplianceRate;

  const AnalyticsSummary({
    required this.currentWeight,
    required this.weightChange,
    required this.averageCalories,
    required this.waterComplianceRate,
  });

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummary(
      currentWeight: (json['currentWeight'] as num?)?.toDouble() ?? 0,
      weightChange: (json['weightChange'] as num?)?.toDouble() ?? 0,
      averageCalories: (json['averageCalories'] as num?)?.toDouble() ?? 0,
      waterComplianceRate:
          (json['waterComplianceRate'] as num?)?.toDouble() ?? 0,
    );
  }
}

class WeeklyAdherencePoint {
  final String date;
  final int calories;
  final int targetCalories;
  final int protein;
  final int targetProtein;

  const WeeklyAdherencePoint({
    required this.date,
    required this.calories,
    required this.targetCalories,
    required this.protein,
    required this.targetProtein,
  });

  factory WeeklyAdherencePoint.fromJson(Map<String, dynamic> json) {
    return WeeklyAdherencePoint(
      date: json['date'] as String? ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      targetCalories: (json['targetCalories'] as num?)?.toInt() ?? 2000,
      protein: (json['protein'] as num?)?.toInt() ?? 0,
      targetProtein: (json['targetProtein'] as num?)?.toInt() ?? 150,
    );
  }
}

class WeightPoint {
  final String date;
  final double weightKg;

  const WeightPoint({required this.date, required this.weightKg});

  factory WeightPoint.fromJson(Map<String, dynamic> json) {
    return WeightPoint(
      date: json['date'] as String? ?? '',
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0,
    );
  }
}
