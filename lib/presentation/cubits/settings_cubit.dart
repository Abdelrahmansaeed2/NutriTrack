import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleDarkTheme(bool val) {
    emit(state.copyWith(isDarkTheme: val));
  }

  void logout() {
    // Emulate logout sequence
    emit(state.copyWith(authState: AuthenticationState.unauthenticated));
  }
}
