


class WaterLogEntry {
  final String label;
  final int ml;
  final String time;
  final WaterEntryType type;

  const WaterLogEntry({
    required this.label,
    required this.ml,
    required this.time,
    required this.type,
  });
}


enum WaterEntryType { glass, bottle, custom }


class QuickAddOption {
  final String label;
  final String sublabel;
  final int ml;
  final WaterEntryType type;

  const QuickAddOption({
    required this.label,
    required this.sublabel,
    required this.ml,
    required this.type,
  });
}


class WaterState {
  final double currentLiters;
  final double goalLiters;
  final List<WaterLogEntry> log;

  const WaterState({
    required this.currentLiters,
    required this.goalLiters,
    required this.log,
  });

  double get progress => (currentLiters / goalLiters).clamp(0.0, 1.0);

  String get motivationText {
    if (progress >= 1.0) return 'Goal reached! Great job! 🎉';
    if (progress >= 0.8) return "You're almost there! Keep hydrating.";
    if (progress >= 0.5) return 'Halfway there, keep it up!';
    return 'Stay hydrated, drink more water!';
  }

  WaterState addEntry(WaterLogEntry entry) {
    return WaterState(
      currentLiters: currentLiters + (entry.ml / 1000),
      goalLiters: goalLiters,
      log: [entry, ...log],
    );
  }
}