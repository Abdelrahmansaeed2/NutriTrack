import 'package:firebase_auth/firebase_auth.dart';

class TokenService {
  static TokenService? _instance;

  TokenService._internal();

  static TokenService get instance {
    _instance ??= TokenService._internal();
    return _instance!;
  }

  /// Returns the current user's Firebase ID token, refreshing if necessary.
  /// Returns null if no user is signed in.
  Future<String?> getToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;
      // forceRefresh: false — Firebase SDK auto-refreshes when near expiry
      return await user.getIdToken(false);
    } catch (e) {
      return null;
    }
  }
}
