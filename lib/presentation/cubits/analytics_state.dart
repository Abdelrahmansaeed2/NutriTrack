import 'package:equatable/equatable.dart';
import '../../features/tracking/models/analytics_model.dart';

enum AnalyticsStatus { initial, loading, loaded, error }

class AnalyticsState extends Equatable {
  final AnalyticsStatus status;
  final AnalyticsDashboard? dashboard;
  final String? errorMessage;

  const AnalyticsState({
    this.status = AnalyticsStatus.initial,
    this.dashboard,
    this.errorMessage,
  });

  AnalyticsState copyWith({
    AnalyticsStatus? status,
    AnalyticsDashboard? dashboard,
    String? errorMessage,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, dashboard, errorMessage];
}
