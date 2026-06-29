import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/tracking/services/analytics_service.dart';
import '../../core/errors/api_exception.dart';
import 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit() : super(const AnalyticsState()) {
    loadStats();
  }

  Future<void> loadStats() async {
    emit(state.copyWith(status: AnalyticsStatus.loading));
    try {
      final dashboard = await AnalyticsService.instance.getDashboardStats();
      emit(state.copyWith(
        status: AnalyticsStatus.loaded,
        dashboard: dashboard,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: AnalyticsStatus.error, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(
        status: AnalyticsStatus.error,
        errorMessage: 'Failed to load analytics.',
      ));
    }
  }

  Future<void> exportData() async {
    try {
      await AnalyticsService.instance.exportData();
    } on ApiException catch (e) {
      emit(state.copyWith(status: AnalyticsStatus.error, errorMessage: e.message));
    }
  }
}
