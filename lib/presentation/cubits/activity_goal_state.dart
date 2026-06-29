import 'package:equatable/equatable.dart';

enum ActivityLevel { sedentary, active, athlete, unselected }

class ActivityGoalState extends Equatable {
  final ActivityLevel selectedActivityLevel;

  const ActivityGoalState({
    this.selectedActivityLevel = ActivityLevel.unselected,
  });

  ActivityGoalState copyWith({
    ActivityLevel? selectedActivityLevel,
  }) {
    return ActivityGoalState(
      selectedActivityLevel: selectedActivityLevel ?? this.selectedActivityLevel,
    );
  }

  bool get isNextEnabled => selectedActivityLevel != ActivityLevel.unselected;

  @override
  List<Object?> get props => [selectedActivityLevel];
}
