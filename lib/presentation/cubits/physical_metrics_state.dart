import 'package:equatable/equatable.dart';

enum Gender { male, female, unselected }

class PhysicalMetricsState extends Equatable {
  final Gender selectedGender;
  final int age;
  final double heightCm;
  final double currentWeightKg;
  final double targetWeightKg;

  const PhysicalMetricsState({
    this.selectedGender = Gender.unselected,
    this.age = 30,
    this.heightCm = 175.0,
    this.currentWeightKg = 75.5,
    this.targetWeightKg = 70.0,
  });

  PhysicalMetricsState copyWith({
    Gender? selectedGender,
    int? age,
    double? heightCm,
    double? currentWeightKg,
    double? targetWeightKg,
  }) {
    return PhysicalMetricsState(
      selectedGender: selectedGender ?? this.selectedGender,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
    );
  }

  bool get isNextEnabled => selectedGender != Gender.unselected;

  @override
  List<Object?> get props => [
        selectedGender,
        age,
        heightCm,
        currentWeightKg,
        targetWeightKg,
      ];
}
