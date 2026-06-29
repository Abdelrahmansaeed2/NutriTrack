import 'package:equatable/equatable.dart';
import '../../features/ai_planner/models/weekly_plan_model.dart';

enum WeeklyPlannerStatus { initial, loading, loaded, error, swapping }

class WeeklyPlannerState extends Equatable {
  final WeeklyPlannerStatus status;
  final DateTime selectedDate;
  final WeeklyPlan? plan;
  final String? errorMessage;

  const WeeklyPlannerState({
    this.status = WeeklyPlannerStatus.initial,
    required this.selectedDate,
    this.plan,
    this.errorMessage,
  });

  bool get isSwapping => status == WeeklyPlannerStatus.swapping;

  WeeklyPlannerState copyWith({
    WeeklyPlannerStatus? status,
    DateTime? selectedDate,
    WeeklyPlan? plan,
    String? errorMessage,
  }) {
    return WeeklyPlannerState(
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      plan: plan ?? this.plan,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, selectedDate, plan, errorMessage];
}
