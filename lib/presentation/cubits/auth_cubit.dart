import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/services/auth_service.dart';
import '../../core/errors/api_exception.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial()) {
    // Listen to Firebase auth state changes so UI reacts automatically
    AuthService.instance.authStateChanges.listen((user) {
      if (isClosed) return;
      if (user != null) {
        emit(AuthAuthenticated(
          email: user.email ?? '',
          uid: user.uid,
          isPasswordVisible: state.isPasswordVisible,
          rememberMe: state.rememberMe,
        ));
      } else {
        if (state is AuthAuthenticated) {
          emit(AuthInitial(
            isPasswordVisible: state.isPasswordVisible,
            rememberMe: state.rememberMe,
          ));
        }
      }
    });
  }

  void togglePasswordVisibility() {
    final s = state;
    if (s is AuthInitial) emit(AuthInitial(isPasswordVisible: !s.isPasswordVisible, rememberMe: s.rememberMe));
    else if (s is AuthAuthenticated) emit(AuthAuthenticated(email: s.email, uid: s.uid, isPasswordVisible: !s.isPasswordVisible, rememberMe: s.rememberMe));
    else if (s is AuthError) emit(AuthError(message: s.message, isPasswordVisible: !s.isPasswordVisible, rememberMe: s.rememberMe));
  }

  void toggleRememberMe() {
    final s = state;
    if (s is AuthInitial) emit(AuthInitial(isPasswordVisible: s.isPasswordVisible, rememberMe: !s.rememberMe));
    else if (s is AuthAuthenticated) emit(AuthAuthenticated(email: s.email, uid: s.uid, isPasswordVisible: s.isPasswordVisible, rememberMe: !s.rememberMe));
    else if (s is AuthError) emit(AuthError(message: s.message, isPasswordVisible: s.isPasswordVisible, rememberMe: !s.rememberMe));
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    emit(AuthLoading(isPasswordVisible: state.isPasswordVisible, rememberMe: state.rememberMe));
    try {
      final user = await AuthService.instance.loginWithEmail(email, password);
      emit(AuthAuthenticated(
        email: user.email ?? email,
        uid: user.uid,
        isPasswordVisible: state.isPasswordVisible,
        rememberMe: state.rememberMe,
      ));
    } on ApiException catch (e) {
      emit(AuthError(
        message: e.message,
        isPasswordVisible: state.isPasswordVisible,
        rememberMe: state.rememberMe,
      ));
    } catch (_) {
      emit(AuthError(
        message: 'An unexpected error occurred. Please try again.',
        isPasswordVisible: state.isPasswordVisible,
        rememberMe: state.rememberMe,
      ));
    }
  }

  Future<void> sendForgotPassword(String email) async {
    try {
      await AuthService.instance.sendForgotPassword(email);
    } catch (_) {
      // Silently fail — don't reveal whether email exists
    }
  }

  Future<void> signOut() async {
    await AuthService.instance.signOut();
    emit(const AuthInitial());
  }
}
