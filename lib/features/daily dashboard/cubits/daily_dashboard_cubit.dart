import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/daily_dashboard_service.dart';
import 'daily_dashboard_state.dart';

class DailyDashboardCubit extends Cubit<DailyDashboardState> {
  final DailyDashboardService _service;

  DailyDashboardCubit(this._service) : super(DailyDashboardInitial());

  Future<void> loadDailyLog(String date) async {
    emit(DailyDashboardLoading());
    try {
      final log = await _service.getDailyLog(date);
      if (log != null) {
        emit(DailyDashboardLoaded(log));
      } else {
        emit(const DailyDashboardError('Failed to load daily log'));
      }
    } catch (e) {
      emit(DailyDashboardError(e.toString()));
    }
  }

  Future<void> removeMealItem(String date, String mealType, int index) async {
    try {
      final updatedLog = await _service.removeMealItem(date, mealType, index);
      if (updatedLog != null) {
        emit(DailyDashboardLoaded(updatedLog));
      } else {
        emit(const DailyDashboardError('Failed to remove meal item'));
      }
    } catch (e) {
      emit(DailyDashboardError(e.toString()));
    }
  }
}
