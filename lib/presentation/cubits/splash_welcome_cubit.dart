import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_welcome_state.dart';

class SplashWelcomeCubit extends Cubit<SplashWelcomeState> {
  SplashWelcomeCubit() : super(const SplashWelcomeInitial());

  void startOnboarding() {
    emit(const SplashWelcomeNavigateToOnboarding());
    // Reset to initial to allow repeated triggers if needed
    emit(const SplashWelcomeInitial());
  }

  void navigateToLogin() {
    emit(const SplashWelcomeNavigateToLogin());
    // Reset to initial to allow repeated triggers if needed
    emit(const SplashWelcomeInitial());
  }
}
