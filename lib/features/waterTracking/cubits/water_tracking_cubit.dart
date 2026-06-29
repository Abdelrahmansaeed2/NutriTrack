import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/water_tracking_service.dart';
import 'water_tracking_state.dart';

class WaterTrackingCubit extends Cubit<WaterTrackingState> {
  final WaterTrackingService _service;

  WaterTrackingCubit(this._service) : super(WaterTrackingInitial());

  void _emitLoaded(Map<String, dynamic> log) {
    final waterIntake = log['waterIntake'] as Map<String, dynamic>? ?? {};
    final totalMl = (waterIntake['totalMl'] as num?)?.toInt() ?? 0;
    final goalMl = (waterIntake['goalMl'] as num?)?.toInt() ?? 3000;
    final logs = waterIntake['logs'] as List<dynamic>? ?? [];
    emit(WaterTrackingLoaded(totalMl: totalMl, goalMl: goalMl, logs: logs));
  }

  Future<void> loadWaterLog(String date) async {
    emit(WaterTrackingLoading());
    try {
      final log = await _service.getWaterLog(date);
      if (log != null) {
        _emitLoaded(log);
      } else {
        emit(const WaterTrackingError('Failed to load water log'));
      }
    } catch (e) {
      emit(WaterTrackingError(e.toString()));
    }
  }

  Future<void> addWater(String date, int amountMl, String type) async {
    try {
      final log = await _service.addWater(date, amountMl, type);
      if (log != null) {
        _emitLoaded(log);
      } else {
        emit(const WaterTrackingError('Failed to log water'));
      }
    } catch (e) {
      emit(WaterTrackingError(e.toString()));
    }
  }

  Future<void> removeWater(String date, int index) async {
    try {
      final log = await _service.removeWater(date, index);
      if (log != null) {
        _emitLoaded(log);
      } else {
        emit(const WaterTrackingError('Failed to remove water entry'));
      }
    } catch (e) {
      emit(WaterTrackingError(e.toString()));
    }
  }
}
