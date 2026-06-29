import 'package:equatable/equatable.dart';

enum AuthenticationState { authenticated, unauthenticated }

class SettingsState extends Equatable {
  final bool isDarkTheme;
  final AuthenticationState authState;

  const SettingsState({
    this.isDarkTheme = false, // From Trace: Inactive
    this.authState = AuthenticationState.authenticated,
  });

  SettingsState copyWith({
    bool? isDarkTheme,
    AuthenticationState? authState,
  }) {
    return SettingsState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      authState: authState ?? this.authState,
    );
  }

  @override
  List<Object?> get props => [isDarkTheme, authState];
}
