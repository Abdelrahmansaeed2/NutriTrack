import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/settings_service.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsService _service;

  SettingsCubit(this._service) : super(SettingsInitial());

  Future<void> logout() async {
    emit(SettingsLoading());
    try {
      await _service.logout();
      emit(SettingsSuccess());
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
