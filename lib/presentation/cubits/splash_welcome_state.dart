import 'package:equatable/equatable.dart';

abstract class SplashWelcomeState extends Equatable {
  const SplashWelcomeState();

  @override
  List<Object?> get props => [];
}

class SplashWelcomeInitial extends SplashWelcomeState {
  const SplashWelcomeInitial();
}

class SplashWelcomeNavigateToOnboarding extends SplashWelcomeState {
  const SplashWelcomeNavigateToOnboarding();
}

class SplashWelcomeNavigateToLogin extends SplashWelcomeState {
  const SplashWelcomeNavigateToLogin();
}
