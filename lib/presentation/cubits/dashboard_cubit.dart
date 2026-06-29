import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/tracking/services/tracking_service.dart';
import '../../core/errors/api_exception.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit()
      : super(DashboardState(selectedDate: DateTime.now())) {
    loadDay(DateTime.now());
  }

  Future<void> loadDay(DateTime date) async {
    emit(state.copyWith(status: DashboardStatus.loading, selectedDate: date));
    try {
      final log = await TrackingService.instance.getDailyLog(date);
      emit(state.copyWith(status: DashboardStatus.loaded, dailyLog: log));
    } on ApiException catch (e) {
      emit(state.copyWith(status: DashboardStatus.error, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(
        status: DashboardStatus.error,
        errorMessage: 'Failed to load daily log.',
      ));
    }
  }

  void selectDate(DateTime date) {
    loadDay(date);
  }

  Future<void> deleteMealItem(String mealType, int index) async {
    try {
      await TrackingService.instance.deleteMeal(state.selectedDate, mealType, index);
      await loadDay(state.selectedDate);
    } on ApiException catch (e) {
      emit(state.copyWith(status: DashboardStatus.error, errorMessage: e.message));
    }
  }
}
