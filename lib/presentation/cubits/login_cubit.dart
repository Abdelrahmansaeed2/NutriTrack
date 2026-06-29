import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void emailChanged(String val) {
    emit(state.copyWith(email: val, status: LoginStatus.initial));
  }

  void passwordChanged(String val) {
    emit(state.copyWith(password: val, status: LoginStatus.initial));
  }

  void toggleRememberMe() {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  void toggleObscurePassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> signIn() async {
    final email = state.email.trim();
    final password = state.password.trim();

    if (email.isEmpty || password.isEmpty) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: "Email and password cannot be empty",
      ));
      return;
    }
    if (!email.contains("@")) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: "Invalid email address",
      ));
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading));
    
    // Simulate API authentication call
    await Future.delayed(const Duration(milliseconds: 1200));
    
    emit(state.copyWith(status: LoginStatus.success));
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.loading));
    await Future.delayed(const Duration(milliseconds: 1000));
    emit(state.copyWith(status: LoginStatus.success));
  }

  Future<void> signInWithApple() async {
    emit(state.copyWith(status: LoginStatus.loading));
    await Future.delayed(const Duration(milliseconds: 1000));
    emit(state.copyWith(status: LoginStatus.success));
  }
}
