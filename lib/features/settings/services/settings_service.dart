import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutri_track/core/helper/shared_pref_helper.dart';

class SettingsService {
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await SharedPrefHelper.clearAllData();
    } catch (_) {}
  }
}
