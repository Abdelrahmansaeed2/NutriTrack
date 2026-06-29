import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  final bool isPasswordVisible;
  final bool rememberMe;
  const AuthState({this.isPasswordVisible = false, this.rememberMe = false});
  @override
  List<Object?> get props => [isPasswordVisible, rememberMe];
}

class AuthInitial extends AuthState {
  const AuthInitial({super.isPasswordVisible, super.rememberMe});
}

class AuthLoading extends AuthState {
  const AuthLoading({super.isPasswordVisible, super.rememberMe});
}

class AuthAuthenticated extends AuthState {
  final String email;
  final String uid;
  const AuthAuthenticated({
    required this.email,
    required this.uid,
    super.isPasswordVisible,
    super.rememberMe,
  });
  @override
  List<Object?> get props => [email, uid, isPasswordVisible, rememberMe];
}

class AuthError extends AuthState {
  final String message;
  const AuthError({
    required this.message,
    super.isPasswordVisible,
    super.rememberMe,
  });
  @override
  List<Object?> get props => [message, isPasswordVisible, rememberMe];
}
