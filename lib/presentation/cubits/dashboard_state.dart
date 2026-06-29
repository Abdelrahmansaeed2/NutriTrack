import 'package:equatable/equatable.dart';
import '../../features/tracking/models/daily_log_model.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DateTime selectedDate;
  final DailyLog? dailyLog;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    required this.selectedDate,
    this.dailyLog,
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    DateTime? selectedDate,
    DailyLog? dailyLog,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      dailyLog: dailyLog ?? this.dailyLog,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, selectedDate, dailyLog, errorMessage];
}
