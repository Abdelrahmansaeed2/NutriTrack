import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/tracking/services/tracking_service.dart';
import '../../features/tracking/models/daily_log_model.dart';
import '../../core/errors/api_exception.dart';
import 'water_tracking_state.dart';

class WaterTrackingCubit extends Cubit<WaterTrackingState> {
  WaterTrackingCubit() : super(const WaterTrackingState()) {
    loadToday();
  }

  Future<void> loadToday() async {
    emit(state.copyWith(status: WaterStatus.loading));
    try {
      final log = await TrackingService.instance.getDailyLog(DateTime.now());
      emit(state.copyWith(
        status: WaterStatus.loaded,
        todaysLog: log.waterIntake,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: WaterStatus.error, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(status: WaterStatus.error, errorMessage: 'Failed to load water log.'));
    }
  }

  Future<void> addWaterIntake(int amountMl, {String type = 'water'}) async {
    try {
      await TrackingService.instance.logWater(DateTime.now(), amountMl, type: type);
      // Optimistically add to state while waiting for server confirmation
      final newEntry = WaterEntry(
        amountMl: amountMl,
        type: type,
        timestamp: DateTime.now(),
      );
      final updated = [newEntry, ...state.todaysLog];
      emit(state.copyWith(status: WaterStatus.loaded, todaysLog: updated));
    } on ApiException catch (e) {
      emit(state.copyWith(status: WaterStatus.error, errorMessage: e.message));
    }
  }

  Future<void> deleteEntry(int index) async {
    try {
      await TrackingService.instance.deleteWater(DateTime.now(), index);
      final updated = List<WaterEntry>.from(state.todaysLog)..removeAt(index);
      emit(state.copyWith(todaysLog: updated));
    } on ApiException catch (e) {
      emit(state.copyWith(status: WaterStatus.error, errorMessage: e.message));
    }
  }
}
