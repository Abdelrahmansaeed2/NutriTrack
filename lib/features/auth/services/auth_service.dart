import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/errors/api_exception.dart';
import '../../../core/network/api_client.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance {
    _instance ??= AuthService._();
    return _instance!;
  }
  AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Signs in with Firebase email/password. Returns the Firebase User on success.
  Future<User> loginWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw ApiException(message: _mapFirebaseError(e.code));
    }
  }

  /// Sends a password reset link via the backend endpoint.
  Future<void> sendForgotPassword(String email) async {
    try {
      await ApiClient.instance.post(
        '/api/users/forgot-password',
        data: {'email': email.trim()},
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Signs out from Firebase.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Returns the currently signed-in user, or null.
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please wait and try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check and try again.';
      default:
        return 'Login failed. Please try again.';
    }
  }
}
