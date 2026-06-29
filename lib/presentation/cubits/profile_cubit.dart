import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/services/user_service.dart';
import '../../core/errors/api_exception.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final profile = await UserService.instance.getProfile();
      emit(state.copyWith(status: ProfileStatus.loaded, profile: profile));
    } on ApiException catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to load profile.',
      ));
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      final updated = await UserService.instance.updateProfile(data);
      emit(state.copyWith(status: ProfileStatus.loaded, profile: updated));
    } on ApiException catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: e.message));
    }
  }
}
