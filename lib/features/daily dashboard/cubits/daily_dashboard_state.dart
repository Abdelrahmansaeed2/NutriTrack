import 'package:equatable/equatable.dart';

abstract class DailyDashboardState extends Equatable {
  const DailyDashboardState();

  @override
  List<Object?> get props => [];
}

class DailyDashboardInitial extends DailyDashboardState {}

class DailyDashboardLoading extends DailyDashboardState {}

class DailyDashboardLoaded extends DailyDashboardState {
  final Map<String, dynamic> logData;

  const DailyDashboardLoaded(this.logData);

  @override
  List<Object?> get props => [logData];
}

class DailyDashboardError extends DailyDashboardState {
  final String message;

  const DailyDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
