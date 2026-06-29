import 'package:flutter_bloc/flutter_bloc.dart';
import 'physical_metrics_state.dart';

class PhysicalMetricsCubit extends Cubit<PhysicalMetricsState> {
  PhysicalMetricsCubit() : super(const PhysicalMetricsState());

  void selectGender(Gender gender) {
    emit(state.copyWith(selectedGender: gender));
  }

  void updateAge(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null && parsed > 0 && parsed < 120) {
      emit(state.copyWith(age: parsed));
    }
  }

  void updateHeight(double value) {
    emit(state.copyWith(heightCm: value));
  }

  void updateCurrentWeight(String value) {
    final parsed = double.tryParse(value);
    if (parsed != null && parsed > 0) {
      emit(state.copyWith(currentWeightKg: parsed));
    }
  }

  void updateTargetWeight(String value) {
    final parsed = double.tryParse(value);
    if (parsed != null && parsed > 0) {
      emit(state.copyWith(targetWeightKg: parsed));
    }
  }
}
