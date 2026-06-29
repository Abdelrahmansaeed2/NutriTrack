import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/profile_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileService _service;

  ProfileCubit(this._service) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await _service.getProfile();
      if (profile != null) {
        emit(ProfileLoaded(profile));
      } else {
        emit(ProfileLoaded(const {
          'name': 'User',
          'bio': 'Dedicated to achieving peak performance through precise nutrition.',
          'onboarding': {
            'biologicalSex': 'Male',
            'age': 25,
            'heightCm': 175,
            'weightKg': 70,
            'targetWeightKg': 70,
            'activityLevel': 'Active',
            'bmr': 1600
          },
          'targets': {
            'dailyCalories': 2100,
            'proteinGrams': 150,
            'carbsGrams': 200,
            'fatGrams': 70
          }
        }));
      }
    } catch (e) {
      emit(ProfileLoaded(const {
        'name': 'User',
        'bio': 'Dedicated to achieving peak performance through precise nutrition.',
        'onboarding': {
          'biologicalSex': 'Male',
          'age': 25,
          'heightCm': 175,
          'weightKg': 70,
          'targetWeightKg': 70,
          'activityLevel': 'Active',
          'bmr': 1600
        },
        'targets': {
          'dailyCalories': 2100,
          'proteinGrams': 150,
          'carbsGrams': 200,
          'fatGrams': 70
        }
      }));
    }
  }
}
