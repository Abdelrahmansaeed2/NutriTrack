import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  final String biologicalSex;
  final int age;
  final double height;
  final double weight;
  final double targetWeight;
  final String activityLevel;
  final int bmr;
  final int dailyTargetKcal;

  const OnboardingState({
    required this.biologicalSex,
    required this.age,
    required this.height,
    required this.weight,
    required this.targetWeight,
    required this.activityLevel,
    required this.bmr,
    required this.dailyTargetKcal,
  });

  @override
  List<Object?> get props => [
        biologicalSex,
        age,
        height,
        weight,
        targetWeight,
        activityLevel,
        bmr,
        dailyTargetKcal,
      ];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial()
      : super(
          biologicalSex: "Male",
          age: 30,
          height: 175.0,
          weight: 75.5,
          targetWeight: 70.0,
          activityLevel: "Sedentary",
          bmr: 1850,
          dailyTargetKcal: 2450,
        );
}

class OnboardingProgress extends OnboardingState {
  const OnboardingProgress({
    required super.biologicalSex,
    required super.age,
    required super.height,
    required super.weight,
    required super.targetWeight,
    required super.activityLevel,
    required super.bmr,
    required super.dailyTargetKcal,
  });
}

class OnboardingComplete extends OnboardingState {
  const OnboardingComplete({
    required super.biologicalSex,
    required super.age,
    required super.height,
    required super.weight,
    required super.targetWeight,
    required super.activityLevel,
    required super.bmr,
    required super.dailyTargetKcal,
  });
}

class OnboardingSubmitting extends OnboardingState {
  const OnboardingSubmitting({
    required super.biologicalSex,
    required super.age,
    required super.height,
    required super.weight,
    required super.targetWeight,
    required super.activityLevel,
    required super.bmr,
    required super.dailyTargetKcal,
  });
}

class OnboardingError extends OnboardingState {
  final String message;
  const OnboardingError({
    required this.message,
    required super.biologicalSex,
    required super.age,
    required super.height,
    required super.weight,
    required super.targetWeight,
    required super.activityLevel,
    required super.bmr,
    required super.dailyTargetKcal,
  });

  @override
  List<Object?> get props => [...super.props, message];
}
