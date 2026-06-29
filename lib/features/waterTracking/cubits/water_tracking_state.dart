import 'package:equatable/equatable.dart';

abstract class WaterTrackingState extends Equatable {
  const WaterTrackingState();

  @override
  List<Object?> get props => [];
}

class WaterTrackingInitial extends WaterTrackingState {}

class WaterTrackingLoading extends WaterTrackingState {}

class WaterTrackingLoaded extends WaterTrackingState {
  final int totalMl;
  final int goalMl;
  final List<dynamic> logs;

  const WaterTrackingLoaded({
    required this.totalMl,
    required this.goalMl,
    required this.logs,
  });

  @override
  List<Object?> get props => [totalMl, goalMl, logs];
}

class WaterTrackingError extends WaterTrackingState {
  final String message;

  const WaterTrackingError(this.message);

  @override
  List<Object?> get props => [message];
}
