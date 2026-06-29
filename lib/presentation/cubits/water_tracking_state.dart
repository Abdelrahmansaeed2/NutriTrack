import 'package:equatable/equatable.dart';
import '../../features/tracking/models/daily_log_model.dart';

enum WaterStatus { initial, loading, loaded, error }

class WaterTrackingState extends Equatable {
  final WaterStatus status;
  final List<WaterEntry> todaysLog;
  final int goalMl;
  final String? errorMessage;

  const WaterTrackingState({
    this.status = WaterStatus.initial,
    this.todaysLog = const [],
    this.goalMl = 3000,
    this.errorMessage,
  });

  int get currentIntakeMl => todaysLog.fold(0, (sum, e) => sum + e.amountMl);

  WaterTrackingState copyWith({
    WaterStatus? status,
    List<WaterEntry>? todaysLog,
    int? goalMl,
    String? errorMessage,
  }) {
    return WaterTrackingState(
      status: status ?? this.status,
      todaysLog: todaysLog ?? this.todaysLog,
      goalMl: goalMl ?? this.goalMl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, todaysLog, goalMl, errorMessage];
}
