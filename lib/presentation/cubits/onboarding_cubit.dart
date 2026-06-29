import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/services/user_service.dart';
import '../../core/errors/api_exception.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingInitial());

  void setSex(String sex) => _updateMetrics(sex: sex);
  void setAge(int age) => _updateMetrics(age: age);
  void setHeight(double height) => _updateMetrics(height: height);
  void setWeight(double weight) => _updateMetrics(weight: weight);
  void setTargetWeight(double targetWeight) => _updateMetrics(targetWeight: targetWeight);

  void setActivityLevel(String level) {
    int additionalCalories = 600;
    if (level == 'Active') additionalCalories = 900;
    else if (level == 'Athlete') additionalCalories = 1200;
    emit(OnboardingProgress(
      biologicalSex: state.biologicalSex,
      age: state.age,
      height: state.height,
      weight: state.weight,
      targetWeight: state.targetWeight,
      activityLevel: level,
      bmr: state.bmr,
      dailyTargetKcal: state.bmr + additionalCalories,
    ));
  }

  /// Submits onboarding data to the backend and emits OnboardingComplete on success
  Future<void> completeSetup() async {
    emit(OnboardingSubmitting(
      biologicalSex: state.biologicalSex,
      age: state.age,
      height: state.height,
      weight: state.weight,
      targetWeight: state.targetWeight,
      activityLevel: state.activityLevel,
      bmr: state.bmr,
      dailyTargetKcal: state.dailyTargetKcal,
    ));
    try {
      await UserService.instance.onboardUser({
        'biologicalSex': state.biologicalSex,
        'age': state.age,
        'heightCm': state.height,
        'weightKg': state.weight,
        'targetWeightKg': state.targetWeight,
        'activityLevel': state.activityLevel,
      });
      emit(OnboardingComplete(
        biologicalSex: state.biologicalSex,
        age: state.age,
        height: state.height,
        weight: state.weight,
        targetWeight: state.targetWeight,
        activityLevel: state.activityLevel,
        bmr: state.bmr,
        dailyTargetKcal: state.dailyTargetKcal,
      ));
    } on ApiException catch (e) {
      emit(OnboardingError(
        message: e.message,
        biologicalSex: state.biologicalSex,
        age: state.age,
        height: state.height,
        weight: state.weight,
        targetWeight: state.targetWeight,
        activityLevel: state.activityLevel,
        bmr: state.bmr,
        dailyTargetKcal: state.dailyTargetKcal,
      ));
    } catch (_) {
      emit(OnboardingError(
        message: 'Failed to save your data. Please try again.',
        biologicalSex: state.biologicalSex,
        age: state.age,
        height: state.height,
        weight: state.weight,
        targetWeight: state.targetWeight,
        activityLevel: state.activityLevel,
        bmr: state.bmr,
        dailyTargetKcal: state.dailyTargetKcal,
      ));
    }
  }

  void _updateMetrics({String? sex, int? age, double? height, double? weight, double? targetWeight}) {
    final sSex = sex ?? state.biologicalSex;
    final sAge = age ?? state.age;
    final sHeight = height ?? state.height;
    final sWeight = weight ?? state.weight;
    final sTargetWeight = targetWeight ?? state.targetWeight;

    double calculatedBmr;
    if (sSex == 'Male') {
      calculatedBmr = (10 * sWeight) + (6.25 * sHeight) - (5 * sAge) + 5;
    } else {
      calculatedBmr = (10 * sWeight) + (6.25 * sHeight) - (5 * sAge) - 161;
    }

    int finalBmr = calculatedBmr.round();
    if (finalBmr < 1000) finalBmr = 1850;

    int additionalCalories = 600;
    if (state.activityLevel == 'Active') additionalCalories = 900;
    else if (state.activityLevel == 'Athlete') additionalCalories = 1200;

    emit(OnboardingProgress(
      biologicalSex: sSex,
      age: sAge,
      height: sHeight,
      weight: sWeight,
      targetWeight: sTargetWeight,
      activityLevel: state.activityLevel,
      bmr: finalBmr,
      dailyTargetKcal: finalBmr + additionalCalories,
    ));
  }
}
